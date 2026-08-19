package com.example.Scott.responsitory;

import com.example.Scott.entity.ChiTietSanPham;
import com.example.Scott.entity.MauSac;
import com.example.Scott.entity.Size;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;

import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import org.hibernate.query.Query;

public class ChiTietSanPhamResponsitory {

    public List<ChiTietSanPham> getAll(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from ChiTietSanPham ", ChiTietSanPham.class).list();
        }
    }


    /** Danh sách biến thể có lọc và phân trang cho màn hình quản trị. */
    public List<ChiTietSanPham> getPage(String keyword, Integer idSanPham, Integer idMauSac,
                                        Integer idSize, String tonKho, String soLuong, Integer trangThai,
                                        BigDecimal giaToiDa, int page, int pageSize) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT ct FROM ChiTietSanPham ct " +
                            "JOIN FETCH ct.sanPham sp JOIN FETCH ct.mauSac ms JOIN FETCH ct.size sz WHERE 1=1");
            appendFilter(hql, keyword, idSanPham, idMauSac, idSize, tonKho, soLuong, trangThai, giaToiDa);
            hql.append(" ORDER BY ct.id DESC");
            Query<ChiTietSanPham> q = s.createQuery(hql.toString(), ChiTietSanPham.class);
            bindFilter(q, keyword, idSanPham, idMauSac, idSize, trangThai, giaToiDa);
            q.setFirstResult((Math.max(1, page) - 1) * Math.max(1, pageSize));
            q.setMaxResults(Math.max(1, pageSize));
            return q.list();
        }
    }

    public long countPage(String keyword, Integer idSanPham, Integer idMauSac,
                          Integer idSize, String tonKho, String soLuong, Integer trangThai, BigDecimal giaToiDa) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT COUNT(ct.id) FROM ChiTietSanPham ct " +
                            "JOIN ct.sanPham sp JOIN ct.mauSac ms JOIN ct.size sz WHERE 1=1");
            appendFilter(hql, keyword, idSanPham, idMauSac, idSize, tonKho, soLuong, trangThai, giaToiDa);
            Query<Long> q = s.createQuery(hql.toString(), Long.class);
            bindFilter(q, keyword, idSanPham, idMauSac, idSize, trangThai, giaToiDa);
            Long result = q.uniqueResult();
            return result == null ? 0L : result;
        }
    }

    private void appendFilter(StringBuilder hql, String keyword, Integer idSanPham, Integer idMauSac,
                              Integer idSize, String tonKho, String soLuong, Integer trangThai, BigDecimal giaToiDa) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" AND (LOWER(ct.ma) LIKE :kw OR LOWER(sp.maSanPham) LIKE :kw " +
                    "OR LOWER(sp.tenSanPham) LIKE :kw OR LOWER(ms.ten) LIKE :kw OR LOWER(sz.ten) LIKE :kw)");
        }
        if (idSanPham != null) hql.append(" AND sp.id = :idSanPham");
        if (idMauSac != null) hql.append(" AND ms.id = :idMauSac");
        if (idSize != null) hql.append(" AND sz.id = :idSize");
        if ("con-hang".equals(tonKho)) hql.append(" AND ct.soLuongTon > 0");
        if ("het-hang".equals(tonKho)) hql.append(" AND (ct.soLuongTon IS NULL OR ct.soLuongTon <= 0)");
        if ("0".equals(soLuong)) hql.append(" AND ct.soLuongTon = 0");
        if ("1-10".equals(soLuong)) hql.append(" AND ct.soLuongTon BETWEEN 1 AND 10");
        if ("11-50".equals(soLuong)) hql.append(" AND ct.soLuongTon BETWEEN 11 AND 50");
        if ("51+".equals(soLuong)) hql.append(" AND ct.soLuongTon >= 51");
        if (trangThai != null) hql.append(" AND ct.trangThai = :trangThai");
        if (giaToiDa != null) hql.append(" AND ct.giaBan <= :giaToiDa");
    }

    private void bindFilter(Query<?> q, String keyword, Integer idSanPham, Integer idMauSac,
                            Integer idSize, Integer trangThai, BigDecimal giaToiDa) {
        if (keyword != null && !keyword.trim().isEmpty()) q.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
        if (idSanPham != null) q.setParameter("idSanPham", idSanPham);
        if (idMauSac != null) q.setParameter("idMauSac", idMauSac);
        if (idSize != null) q.setParameter("idSize", idSize);
        if (trangThai != null) q.setParameter("trangThai", trangThai);
        if (giaToiDa != null) q.setParameter("giaToiDa", giaToiDa);
    }

    /**
     * Tim bien the san pham dang ban va con ton kho, dung cho man hinh
     * Ban hang tai quay (goi qua AJAX). Gioi han 30 ket qua de tra ve nhanh.
     */
    public List<ChiTietSanPham> searchForBanHang(String keyword){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT ct FROM ChiTietSanPham ct " +
                            "JOIN FETCH ct.sanPham sp JOIN FETCH ct.mauSac ms JOIN FETCH ct.size sz " +
                            // sp.trangThai = 1: sản phẩm (cấp cha) phải đang bán — nếu sản phẩm đã bị
                            // ngừng bán (thủ công hoặc tự động do hết hàng) thì KHÔNG được tìm thấy ở
                            // màn hình Bán hàng tại quầy dù 1 biến thể lẻ nào đó vẫn còn bật trạng thái.
                            "WHERE ct.trangThai = 1 AND ct.soLuongTon > 0 AND sp.trangThai = 1");
            String kw = keyword == null ? "" : keyword.trim().toLowerCase();
            if (!kw.isEmpty()) {
                hql.append(" AND (LOWER(ct.ma) LIKE :kw OR LOWER(sp.maSanPham) LIKE :kw " +
                        "OR LOWER(sp.tenSanPham) LIKE :kw)");
            }
            hql.append(" ORDER BY sp.tenSanPham ASC");
            Query<ChiTietSanPham> q = s.createQuery(hql.toString(), ChiTietSanPham.class);
            if (!kw.isEmpty()) q.setParameter("kw", "%" + kw + "%");
            q.setMaxResults(30);
            return q.list();
        }
    }

    /**
     * Tìm CHÍNH XÁC 1 biến thể theo mã (dùng cho quét QR ở Bán hàng tại quầy).
     * Chỉ trả về nếu biến thể còn bán và sản phẩm cha còn bán; trả về null nếu
     * không tìm thấy hoặc đã ngừng bán, để servlet phân biệt được "không có mã"
     * với "có mã nhưng không thể bán".
     */
    public ChiTietSanPham timTheoMaChinhXac(String ma){
        if (ma == null || ma.trim().isEmpty()) return null;
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT ct FROM ChiTietSanPham ct " +
                    "JOIN FETCH ct.sanPham sp JOIN FETCH ct.mauSac ms JOIN FETCH ct.size sz " +
                    "WHERE ct.ma = :ma AND ct.trangThai = 1 AND sp.trangThai = 1";
            List<ChiTietSanPham> list = s.createQuery(hql, ChiTietSanPham.class)
                    .setParameter("ma", ma.trim())
                    .setMaxResults(1)
                    .list();
            return list.isEmpty() ? null : list.get(0);
        }
    }

    public BigDecimal getMaxGiaBan(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            BigDecimal value = s.createQuery("SELECT MAX(ct.giaBan) FROM ChiTietSanPham ct", BigDecimal.class).uniqueResult();
            return value == null ? BigDecimal.ZERO : value;
        }
    }

    // ================= Bán hàng tại quầy: tìm kiếm có lọc + phân trang =================

    private static final String BAN_HANG_BASE_WHERE =
            " WHERE ct.trangThai = 1 AND sp.trangThai = 1";

    private void appendBanHangFilter(StringBuilder hql, String keyword, Integer idMauSac, Integer idSize,
                                     BigDecimal giaMin, BigDecimal giaMax, String tonKho) {
        String kw = keyword == null ? "" : keyword.trim().toLowerCase();
        if (!kw.isEmpty()) {
            hql.append(" AND (LOWER(ct.ma) LIKE :kw OR LOWER(sp.maSanPham) LIKE :kw " +
                    "OR LOWER(sp.tenSanPham) LIKE :kw)");
        }
        if (idMauSac != null) hql.append(" AND ms.id = :idMauSac");
        if (idSize != null) hql.append(" AND sz.id = :idSize");
        if (giaMin != null) hql.append(" AND ct.giaBan >= :giaMin");
        if (giaMax != null) hql.append(" AND ct.giaBan <= :giaMax");
        if ("con-hang".equals(tonKho)) hql.append(" AND ct.soLuongTon > 0");
        if ("het-hang".equals(tonKho)) hql.append(" AND (ct.soLuongTon IS NULL OR ct.soLuongTon <= 0)");
    }

    private void bindBanHangFilter(Query<?> q, String keyword, Integer idMauSac, Integer idSize,
                                   BigDecimal giaMin, BigDecimal giaMax) {
        String kw = keyword == null ? "" : keyword.trim().toLowerCase();
        if (!kw.isEmpty()) q.setParameter("kw", "%" + kw + "%");
        if (idMauSac != null) q.setParameter("idMauSac", idMauSac);
        if (idSize != null) q.setParameter("idSize", idSize);
        if (giaMin != null) q.setParameter("giaMin", giaMin);
        if (giaMax != null) q.setParameter("giaMax", giaMax);
    }

    /**
     * Tìm biến thể sản phẩm đang bán cho màn hình Bán hàng tại quầy, có lọc theo
     * từ khóa / màu / size / khoảng giá / tình trạng tồn kho, và phân trang.
     */
    public List<ChiTietSanPham> searchForBanHangPage(String keyword, Integer idMauSac, Integer idSize,
                                                     BigDecimal giaMin, BigDecimal giaMax, String tonKho,
                                                     int page, int pageSize) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT ct FROM ChiTietSanPham ct " +
                            "JOIN FETCH ct.sanPham sp JOIN FETCH ct.mauSac ms JOIN FETCH ct.size sz" +
                            BAN_HANG_BASE_WHERE);
            appendBanHangFilter(hql, keyword, idMauSac, idSize, giaMin, giaMax, tonKho);
            hql.append(" ORDER BY sp.tenSanPham ASC, ms.ten ASC, sz.ten ASC");
            Query<ChiTietSanPham> q = s.createQuery(hql.toString(), ChiTietSanPham.class);
            bindBanHangFilter(q, keyword, idMauSac, idSize, giaMin, giaMax);
            q.setFirstResult((Math.max(1, page) - 1) * Math.max(1, pageSize));
            q.setMaxResults(Math.max(1, pageSize));
            return q.list();
        }
    }

    public long countForBanHang(String keyword, Integer idMauSac, Integer idSize,
                                BigDecimal giaMin, BigDecimal giaMax, String tonKho) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT COUNT(ct.id) FROM ChiTietSanPham ct " +
                            "JOIN ct.sanPham sp JOIN ct.mauSac ms JOIN ct.size sz" +
                            BAN_HANG_BASE_WHERE);
            appendBanHangFilter(hql, keyword, idMauSac, idSize, giaMin, giaMax, tonKho);
            Query<Long> q = s.createQuery(hql.toString(), Long.class);
            bindBanHangFilter(q, keyword, idMauSac, idSize, giaMin, giaMax);
            Long result = q.uniqueResult();
            return result == null ? 0L : result;
        }
    }

    /** Khoảng giá [min, max] của các biến thể đang bán, dùng để khởi tạo thanh trượt khoảng giá. */
    public BigDecimal[] getKhoangGiaBanHang() {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT MIN(ct.giaBan), MAX(ct.giaBan) FROM ChiTietSanPham ct " +
                    "JOIN ct.sanPham sp" + BAN_HANG_BASE_WHERE;
            Object[] row = s.createQuery(hql, Object[].class).uniqueResult();
            BigDecimal min = (row != null && row[0] != null) ? (BigDecimal) row[0] : BigDecimal.ZERO;
            BigDecimal max = (row != null && row[1] != null) ? (BigDecimal) row[1] : BigDecimal.ZERO;
            return new BigDecimal[]{min, max};
        }
    }

    /** Danh sách màu sắc đang thực sự có biến thể đang bán, dùng cho dropdown lọc. */
    public List<MauSac> getMauSacDangBan() {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT DISTINCT ms FROM ChiTietSanPham ct JOIN ct.mauSac ms JOIN ct.sanPham sp" +
                    BAN_HANG_BASE_WHERE + " ORDER BY ms.ten ASC";
            return s.createQuery(hql, MauSac.class).list();
        }
    }

    /** Danh sách size đang thực sự có biến thể đang bán, dùng cho dropdown lọc. */
    public List<Size> getSizeDangBan() {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT DISTINCT sz FROM ChiTietSanPham ct JOIN ct.size sz JOIN ct.sanPham sp" +
                    BAN_HANG_BASE_WHERE + " ORDER BY sz.ten ASC";
            return s.createQuery(hql, Size.class).list();
        }
    }

    public ChiTietSanPham getOne(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(ChiTietSanPham.class, id);
        }
    }

    public List<ChiTietSanPham> getBySanPham(Integer idSanPham){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(
                    "FROM ChiTietSanPham WHERE sanPham.id = :id",
                    ChiTietSanPham.class)
                    .setParameter("id", idSanPham)
                    .list();
        }
    }

    /**
     * Kiểm tra trùng mã biến thể, không phân biệt hoa/thường.
     * excludeId = null khi thêm mới; có id khi cập nhật để bỏ qua chính bản ghi đang sửa.
     */
    public boolean existsMa(String ma, Integer excludeId){
        if (ma == null || ma.trim().isEmpty()) return false;

        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(ct.id) FROM ChiTietSanPham ct WHERE UPPER(ct.ma) = :ma";
            if (excludeId != null) hql += " AND ct.id <> :id";

            org.hibernate.query.Query<Long> q = s.createQuery(hql, Long.class)
                    .setParameter("ma", ma.trim().toUpperCase());

            if (excludeId != null) q.setParameter("id", excludeId);

            Long count = q.uniqueResult();
            return count != null && count > 0;
        }
    }


    /**
     * Thêm nhiều biến thể trong cùng một transaction. Nếu một bản ghi lỗi,
     * toàn bộ lô được rollback để tránh trạng thái thêm dở dang.
     */
    public void addMany(List<ChiTietSanPham> danhSach){
        if (danhSach == null || danhSach.isEmpty()) return;
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                for (ChiTietSanPham ct : danhSach) {
                    s.persist(ct);
                }
                s.getTransaction().commit();
            } catch (Exception e) {
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi them nhieu bien the: " + e.getMessage(), e);
            }
        }
    }

    /** Kiểm tra tổ hợp sản phẩm + màu + size đã tồn tại hay chưa. */
    public boolean existsCombination(Integer idSanPham, Integer idMauSac, Integer idSize, Integer excludeId){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(ct.id) FROM ChiTietSanPham ct " +
                    "WHERE ct.sanPham.id = :sp AND ct.mauSac.id = :mau AND ct.size.id = :size";
            if (excludeId != null) hql += " AND ct.id <> :id";
            org.hibernate.query.Query<Long> q = s.createQuery(hql, Long.class)
                    .setParameter("sp", idSanPham)
                    .setParameter("mau", idMauSac)
                    .setParameter("size", idSize);
            if (excludeId != null) q.setParameter("id", excludeId);
            Long count = q.uniqueResult();
            return count != null && count > 0;
        }
    }

    public void addChiTietSanPham(ChiTietSanPham CT){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.persist(CT);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi them bien the san pham: " + e.getMessage(), e);
            }
        }
    }

    public void updateChiTietSanPham(ChiTietSanPham CT){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.merge(CT);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi cap nhat bien the san pham: " + e.getMessage(), e);
            }
        }
    }

    /**
     * Đảo trạng thái Đang bán (1) <-> Ngừng bán (0) của MỘT biến thể, trả về giá trị mới.
     * Trả về null nếu không tìm thấy biến thể. Xem giải thích chi tiết ở
     * SanPhamResponsitory#toggleTrangThai — cùng nguyên lý, áp dụng cho bảng chi_tiet_san_pham.
     */
    public Integer toggleTrangThai(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            ChiTietSanPham ct = s.find(ChiTietSanPham.class, id);
            if (ct == null) return null;
            int moi = (ct.getTrangThai() != null && ct.getTrangThai() == 1) ? 0 : 1;
            try {
                s.getTransaction().begin();
                s.createQuery("UPDATE ChiTietSanPham SET trangThai = :tt WHERE id = :id")
                        .setParameter("tt", moi)
                        .setParameter("id", id)
                        .executeUpdate();
                s.getTransaction().commit();
            } catch (Exception e) {
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi doi trang thai bien the: " + e.getMessage(), e);
            }
            return moi;
        }
    }

    public void DeleteChiTietSanPham(ChiTietSanPham CT){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.delete(CT);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi xoa bien the san pham: " + e.getMessage(), e);
            }
        }
    }

    public List<MauSac> getAllMauSac(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from MauSac ", MauSac.class).list();
        }
    }
    public List<Size> getAllSize(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from Size ", Size.class).list();
        }
    }

    public MauSac getMauSac(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(MauSac.class, id);
        }
    }
    public Size getSize(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(Size.class, id);
        }
    }

    public static void main(String[] args) {
        System.out.println(new ChiTietSanPhamResponsitory().getAll());
    }
}
