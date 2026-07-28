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
                            "WHERE ct.trangThai = 1 AND ct.soLuongTon > 0");
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

    public BigDecimal getMaxGiaBan(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            BigDecimal value = s.createQuery("SELECT MAX(ct.giaBan) FROM ChiTietSanPham ct", BigDecimal.class).uniqueResult();
            return value == null ? BigDecimal.ZERO : value;
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

    public boolean existsMa(String ma, Integer excludeId){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(ct.id) FROM ChiTietSanPham ct WHERE ct.ma = :ma";
            if (excludeId != null) hql += " AND ct.id <> :id";
            org.hibernate.query.Query<Long> q = s.createQuery(hql, Long.class).setParameter("ma", ma);
            if (excludeId != null) q.setParameter("id", excludeId);
            return q.uniqueResult() > 0;
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
