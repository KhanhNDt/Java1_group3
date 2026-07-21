package com.example.Scott.responsitory;

import com.example.Scott.dto.SanPhamListDTO;
import com.example.Scott.entity.ChatLieu;
import com.example.Scott.entity.DanhMuc;
import com.example.Scott.entity.KieuDang;
import com.example.Scott.entity.SanPham;
import com.example.Scott.entity.ThuongHieu;
import com.example.Scott.entity.ChiTietSanPham;
import com.example.Scott.entity.MauSac;
import com.example.Scott.entity.Size;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * QUAN TRONG: KHONG mo Session trong constructor va giu no song mai (truoc day gay loi
 * vi Servlet trong Tomcat la SINGLETON dung chung cho moi request -> 1 Session Hibernate
 * (khong thread-safe) bi nhieu request/thread cung doc-ghi mot luc -> loi ngau nhien,
 * treo trang sau vai lan thao tac).
 * Thay vao do: MOI method tu mo 1 Session rieng bang try-with-resources va TU DONG
 * dong lai ngay sau khi dung xong (Session implements AutoCloseable).
 */
public class SanPhamResponsitory {

    public List<SanPham> getAll(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from SanPham ", SanPham.class).list();
        }
    }

    public SanPham getOne(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(SanPham.class, id);
        }
    }

    public List<SanPham> search(String keyword){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(
                    "FROM SanPham WHERE maSanPham LIKE :kw OR tenSanPham LIKE :kw",
                    SanPham.class)
                    .setParameter("kw", "%" + keyword + "%")
                    .list();
        }
    }

    /**
     * Chỉ JOIN các biến thể đang bán (trangThai = 1). Nhờ đó tổng tồn kho và
     * khoảng giá của sản phẩm không còn tính các biến thể đã ngừng bán.
     */
    private static final String DTO_SELECT =
            "SELECT new com.example.Scott.dto.SanPhamListDTO(" +
            "   sp.id, sp.maSanPham, sp.tenSanPham, dm.tenDanhMuc, th.ten, " +
            "   sp.trangThai, COALESCE(SUM(ct.soLuongTon), 0L), MIN(ct.giaBan), MAX(ct.giaBan)" +
            ") FROM SanPham sp " +
            "   JOIN sp.danhMuc dm " +
            "   JOIN sp.thuongHieu th " +
            "   LEFT JOIN ChiTietSanPham ct ON ct.sanPham = sp AND ct.trangThai = 1 ";
    private static final String DTO_GROUP_ORDER =
            " GROUP BY sp.id, sp.maSanPham, sp.tenSanPham, dm.tenDanhMuc, th.ten, sp.trangThai " +
            " ORDER BY sp.id";

    /**
     * Lấy 1 TRANG dữ liệu cho bảng danh sách (đã tổng hợp Hàng tồn + Khoảng giá).
     * page bắt đầu từ 1, pageSize là số dòng/trang.
     *
     * idDanhMuc / idThuongHieu / trangThai: bộ lọc NÂNG CAO, mỗi tham số có thể null
     * (không lọc theo tiêu chí đó). Đây là kiểu "lọc động" (dynamic query) — thay vì
     * viết cứng nhiều câu HQL cho từng tổ hợp lọc, ta build danh sách điều kiện rồi
     * nối lại bằng AND, tham số nào null thì không thêm điều kiện tương ứng.
     */
    public List<SanPhamListDTO> getPageDanhSach(String keyword, Integer idDanhMuc, Integer idThuongHieu,
                                                 Integer trangThai, String tonKho, String soLuong,
                                                 BigDecimal giaToiDa, String sapXep, int page, int pageSize){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(DTO_SELECT);
            List<String> where = new ArrayList<>();
            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            if (hasKeyword) where.add("(LOWER(sp.maSanPham) LIKE LOWER(:kw) OR LOWER(sp.tenSanPham) LIKE LOWER(:kw) OR LOWER(th.ten) LIKE LOWER(:kw) OR LOWER(dm.tenDanhMuc) LIKE LOWER(:kw) OR EXISTS (SELECT ctTim.id FROM ChiTietSanPham ctTim JOIN ctTim.mauSac msTim JOIN ctTim.size szTim WHERE ctTim.sanPham = sp AND (LOWER(ctTim.ma) LIKE LOWER(:kw) OR LOWER(msTim.ma) LIKE LOWER(:kw) OR LOWER(msTim.ten) LIKE LOWER(:kw) OR LOWER(szTim.ma) LIKE LOWER(:kw) OR LOWER(szTim.ten) LIKE LOWER(:kw))))");
            if (idDanhMuc != null) where.add("dm.id = :idDanhMuc");
            if (idThuongHieu != null) where.add("th.id = :idThuongHieu");
            if (trangThai != null) where.add("sp.trangThai = :trangThai");
            if (!where.isEmpty()) hql.append(" WHERE ").append(String.join(" AND ", where));
            hql.append(" GROUP BY sp.id, sp.maSanPham, sp.tenSanPham, dm.tenDanhMuc, th.ten, sp.trangThai ");
            List<String> having = new ArrayList<>();
            if ("con-hang".equals(tonKho)) having.add("COALESCE(SUM(ct.soLuongTon), 0) > 0");
            if ("het-hang".equals(tonKho)) having.add("COALESCE(SUM(ct.soLuongTon), 0) <= 0");
            if ("0".equals(soLuong)) having.add("COALESCE(SUM(ct.soLuongTon), 0) = 0");
            if ("1-10".equals(soLuong)) having.add("COALESCE(SUM(ct.soLuongTon), 0) BETWEEN 1 AND 10");
            if ("11-50".equals(soLuong)) having.add("COALESCE(SUM(ct.soLuongTon), 0) BETWEEN 11 AND 50");
            if ("51+".equals(soLuong)) having.add("COALESCE(SUM(ct.soLuongTon), 0) >= 51");
            if (giaToiDa != null) having.add("MIN(ct.giaBan) IS NULL OR MIN(ct.giaBan) <= :giaToiDa");
            if (!having.isEmpty()) hql.append(" HAVING (").append(String.join(") AND (", having)).append(")");
            if ("ten-az".equals(sapXep)) hql.append(" ORDER BY sp.tenSanPham ASC");
            else if ("ten-za".equals(sapXep)) hql.append(" ORDER BY sp.tenSanPham DESC");
            else if ("gia-thap".equals(sapXep)) hql.append(" ORDER BY MIN(ct.giaBan) ASC, sp.id DESC");
            else if ("gia-cao".equals(sapXep)) hql.append(" ORDER BY MAX(ct.giaBan) DESC, sp.id DESC");
            else hql.append(" ORDER BY sp.id DESC");
            Query<SanPhamListDTO> q = s.createQuery(hql.toString(), SanPhamListDTO.class);
            if (hasKeyword) q.setParameter("kw", "%" + keyword.trim() + "%");
            if (idDanhMuc != null) q.setParameter("idDanhMuc", idDanhMuc);
            if (idThuongHieu != null) q.setParameter("idThuongHieu", idThuongHieu);
            if (trangThai != null) q.setParameter("trangThai", trangThai);
            if (giaToiDa != null) q.setParameter("giaToiDa", giaToiDa);
            q.setFirstResult((Math.max(page,1)-1) * Math.max(pageSize,1));
            q.setMaxResults(Math.max(pageSize,1));
            return q.list();
        }
    }

    /**
     * Overload tương thích với các màn hình cũ chỉ truyền 4 điều kiện lọc cơ bản.
     * Ba bộ lọc nâng cao (tồn kho, số lượng, giá tối đa) mặc định không áp dụng.
     */
    public long countDanhSach(String keyword, Integer idDanhMuc, Integer idThuongHieu,
                              Integer trangThai) {
        return countDanhSach(keyword, idDanhMuc, idThuongHieu, trangThai, null, null, null);
    }

    /**
     * Overload tương thích với servlet cũ: chưa truyền bộ lọc tồn kho, số lượng và giá tối đa.
     */
    public List<SanPhamListDTO> getPageDanhSach(String keyword, Integer idDanhMuc, Integer idThuongHieu,
                                                 Integer trangThai, String sapXep, int page, int pageSize) {
        return getPageDanhSach(keyword, idDanhMuc, idThuongHieu, trangThai,
                null, null, null, sapXep, page, pageSize);
    }

    /** Đếm tổng số sản phẩm khớp bộ lọc hiện tại (dùng để tính tổng số trang / hiển thị "tổng: X"). */
    public long countDanhSach(String keyword, Integer idDanhMuc, Integer idThuongHieu,
                              Integer trangThai, String tonKho, String soLuong, BigDecimal giaToiDa){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("SELECT sp.id FROM SanPham sp JOIN sp.danhMuc dm JOIN sp.thuongHieu th LEFT JOIN ChiTietSanPham ct ON ct.sanPham = sp AND ct.trangThai = 1");
            List<String> where = new ArrayList<>();
            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            if (hasKeyword) where.add("(LOWER(sp.maSanPham) LIKE LOWER(:kw) OR LOWER(sp.tenSanPham) LIKE LOWER(:kw) OR LOWER(th.ten) LIKE LOWER(:kw) OR LOWER(dm.tenDanhMuc) LIKE LOWER(:kw) OR EXISTS (SELECT ctTim.id FROM ChiTietSanPham ctTim JOIN ctTim.mauSac msTim JOIN ctTim.size szTim WHERE ctTim.sanPham = sp AND (LOWER(ctTim.ma) LIKE LOWER(:kw) OR LOWER(msTim.ma) LIKE LOWER(:kw) OR LOWER(msTim.ten) LIKE LOWER(:kw) OR LOWER(szTim.ma) LIKE LOWER(:kw) OR LOWER(szTim.ten) LIKE LOWER(:kw))))");
            if (idDanhMuc != null) where.add("dm.id = :idDanhMuc");
            if (idThuongHieu != null) where.add("th.id = :idThuongHieu");
            if (trangThai != null) where.add("sp.trangThai = :trangThai");
            if (!where.isEmpty()) hql.append(" WHERE ").append(String.join(" AND ", where));
            hql.append(" GROUP BY sp.id");
            List<String> having = new ArrayList<>();
            if ("con-hang".equals(tonKho)) having.add("COALESCE(SUM(ct.soLuongTon), 0) > 0");
            if ("het-hang".equals(tonKho)) having.add("COALESCE(SUM(ct.soLuongTon), 0) <= 0");
            if ("0".equals(soLuong)) having.add("COALESCE(SUM(ct.soLuongTon), 0) = 0");
            if ("1-10".equals(soLuong)) having.add("COALESCE(SUM(ct.soLuongTon), 0) BETWEEN 1 AND 10");
            if ("11-50".equals(soLuong)) having.add("COALESCE(SUM(ct.soLuongTon), 0) BETWEEN 11 AND 50");
            if ("51+".equals(soLuong)) having.add("COALESCE(SUM(ct.soLuongTon), 0) >= 51");
            if (giaToiDa != null) having.add("MIN(ct.giaBan) IS NULL OR MIN(ct.giaBan) <= :giaToiDa");
            if (!having.isEmpty()) hql.append(" HAVING (").append(String.join(") AND (", having)).append(")");
            Query<Integer> q = s.createQuery(hql.toString(), Integer.class);
            if (hasKeyword) q.setParameter("kw", "%" + keyword.trim() + "%");
            if (idDanhMuc != null) q.setParameter("idDanhMuc", idDanhMuc);
            if (idThuongHieu != null) q.setParameter("idThuongHieu", idThuongHieu);
            if (trangThai != null) q.setParameter("trangThai", trangThai);
            if (giaToiDa != null) q.setParameter("giaToiDa", giaToiDa);
            return q.list().size();
        }
    }

    public BigDecimal getMaxGiaBan(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            BigDecimal value = s.createQuery("SELECT MAX(ct.giaBan) FROM ChiTietSanPham ct WHERE ct.trangThai = 1", BigDecimal.class).uniqueResult();
            return value == null ? BigDecimal.ZERO : value;
        }
    }




    /**
     * Gợi ý tìm kiếm theo mã/tên sản phẩm, thương hiệu, danh mục, màu và size.
     * Kết quả được khử trùng và giới hạn để dropdown luôn gọn.
     */
    public List<Map<String, Object>> getGoiYTimKiem(String keyword, int limit) {
        List<Map<String, Object>> result = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) return result;

        String kw = "%" + keyword.trim().toLowerCase() + "%";
        int max = Math.max(1, Math.min(limit, 15));
        Set<String> unique = new LinkedHashSet<>();

        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            List<Object[]> products = s.createQuery(
                    "SELECT DISTINCT sp.maSanPham, sp.tenSanPham, th.ten, dm.tenDanhMuc " +
                    "FROM SanPham sp JOIN sp.thuongHieu th JOIN sp.danhMuc dm " +
                    "WHERE LOWER(sp.maSanPham) LIKE :kw OR LOWER(sp.tenSanPham) LIKE :kw " +
                    "ORDER BY sp.tenSanPham", Object[].class)
                    .setParameter("kw", kw).setMaxResults(max).list();
            for (Object[] row : products) {
                String ma = String.valueOf(row[0]);
                String ten = String.valueOf(row[1]);
                addSuggestion(result, unique, "Sản phẩm", ten, ma + " · " + row[2] + " · " + row[3], "bi-box-seam", max);
                if (result.size() >= max) return result;
                if (ma.toLowerCase().contains(keyword.trim().toLowerCase())) {
                    addSuggestion(result, unique, "Mã sản phẩm", ma, ten, "bi-upc-scan", max);
                }
                if (result.size() >= max) return result;
            }

            appendSimpleSuggestions(s, result, unique,
                    "SELECT DISTINCT th.ten FROM ThuongHieu th WHERE LOWER(th.ten) LIKE :kw ORDER BY th.ten",
                    kw, "Thương hiệu", "bi-award", max);
            appendSimpleSuggestions(s, result, unique,
                    "SELECT DISTINCT dm.tenDanhMuc FROM DanhMuc dm WHERE LOWER(dm.tenDanhMuc) LIKE :kw ORDER BY dm.tenDanhMuc",
                    kw, "Danh mục", "bi-tags", max);
            appendSimpleSuggestions(s, result, unique,
                    "SELECT DISTINCT ms.ten FROM MauSac ms WHERE LOWER(ms.ten) LIKE :kw OR LOWER(ms.ma) LIKE :kw ORDER BY ms.ten",
                    kw, "Màu sắc", "bi-palette", max);
            appendSimpleSuggestions(s, result, unique,
                    "SELECT DISTINCT sz.ten FROM Size sz WHERE LOWER(sz.ten) LIKE :kw OR LOWER(sz.ma) LIKE :kw ORDER BY sz.ten",
                    kw, "Kích thước", "bi-rulers", max);
        }
        return result;
    }

    private void appendSimpleSuggestions(Session s, List<Map<String, Object>> result, Set<String> unique,
                                         String hql, String kw, String type, String icon, int max) {
        if (result.size() >= max) return;
        List<String> values = s.createQuery(hql, String.class)
                .setParameter("kw", kw)
                .setMaxResults(max - result.size())
                .list();
        for (String value : values) {
            addSuggestion(result, unique, type, value, "Tìm theo " + type.toLowerCase(), icon, max);
            if (result.size() >= max) break;
        }
    }

    private void addSuggestion(List<Map<String, Object>> result, Set<String> unique, String type,
                               String value, String detail, String icon, int max) {
        if (value == null || value.trim().isEmpty() || result.size() >= max) return;
        String key = type + "|" + value.trim().toLowerCase();
        if (!unique.add(key)) return;
        Map<String, Object> item = new LinkedHashMap<>();
        item.put("type", type);
        item.put("value", value.trim());
        item.put("detail", detail);
        item.put("icon", icon);
        result.add(item);
    }

    /**
     * Sinh mã tự động dạng SP0001, SP0002...
     * synchronized giúp các request trong cùng một ứng dụng không lấy cùng một mã.
     * Trước khi trả về vẫn kiểm tra lại DB để không trùng với dữ liệu hiện có.
     */
    public synchronized String generateNextMaSanPham(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            List<String> codes = s.createQuery(
                    "SELECT sp.maSanPham FROM SanPham sp WHERE UPPER(sp.maSanPham) LIKE 'SP%'",
                    String.class).list();

            int max = 0;
            for (String code : codes) {
                if (code == null) continue;
                String normalized = code.trim().toUpperCase();
                if (!normalized.matches("SP\\d+")) continue;
                try {
                    max = Math.max(max, Integer.parseInt(normalized.substring(2)));
                } catch (NumberFormatException ignored) {
                    // Bỏ qua mã cũ không đúng định dạng hoặc vượt giới hạn số.
                }
            }

            int next = max + 1;
            String candidate;
            do {
                candidate = String.format("SP%04d", next++);
            } while (existsMaIgnoreCase(candidate, null));
            return candidate;
        }
    }

    public boolean existsMaIgnoreCase(String ma, Integer excludeId){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(sp.id) FROM SanPham sp WHERE UPPER(sp.maSanPham) = :ma";
            if (excludeId != null) hql += " AND sp.id <> :id";
            Query<Long> q = s.createQuery(hql, Long.class).setParameter("ma", ma.trim().toUpperCase());
            if (excludeId != null) q.setParameter("id", excludeId);
            Long count = q.uniqueResult();
            return count != null && count > 0;
        }
    }

    public boolean existsMa(String ma, Integer excludeId){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(sp.id) FROM SanPham sp WHERE sp.maSanPham = :ma";
            if (excludeId != null) hql += " AND sp.id <> :id";
            org.hibernate.query.Query<Long> q = s.createQuery(hql, Long.class).setParameter("ma", ma);
            if (excludeId != null) q.setParameter("id", excludeId);
            return q.uniqueResult() > 0;
        }
    }

    /**
     * Lưu sản phẩm và toàn bộ biến thể ban đầu trong CÙNG một transaction.
     * Nếu bất kỳ biến thể nào lỗi thì sản phẩm cũng được rollback, tránh sản phẩm rỗng.
     */
    public void addSanPhamKemBienThe(SanPham sp, List<ChiTietSanPham> bienTheList){
        if (sp == null || bienTheList == null || bienTheList.isEmpty()) {
            throw new IllegalArgumentException("Sản phẩm phải có ít nhất một biến thể.");
        }
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();

                // Dùng reference thuộc cùng Session để tránh lỗi detached entity khi persist.
                sp.setThuongHieu(s.getReference(ThuongHieu.class, sp.getThuongHieu().getId()));
                sp.setDanhMuc(s.getReference(DanhMuc.class, sp.getDanhMuc().getId()));
                sp.setChatLieu(s.getReference(ChatLieu.class, sp.getChatLieu().getId()));
                sp.setKieuDang(s.getReference(KieuDang.class, sp.getKieuDang().getId()));
                s.persist(sp);
                s.flush(); // bảo đảm đã có id sản phẩm trước khi lưu chi tiết

                for (ChiTietSanPham ct : bienTheList) {
                    ct.setSanPham(sp);
                    ct.setMauSac(s.getReference(MauSac.class, ct.getMauSac().getId()));
                    ct.setSize(s.getReference(Size.class, ct.getSize().getId()));
                    s.persist(ct);
                }
                s.getTransaction().commit();
            } catch (Exception e) {
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Lỗi khi thêm sản phẩm kèm biến thể: " + e.getMessage(), e);
            }
        }
    }

    public void addSanPham(SanPham SP){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.persist(SP);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                // Nem lai loi de tang controller biet va bao that cho nguoi dung,
                // khong duoc nuot loi im lang roi van bao "thanh cong".
                throw new RuntimeException("Loi khi them san pham: " + e.getMessage(), e);
            }
        }
    }

    public void updateSanPham(SanPham SP){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.merge(SP);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi cap nhat san pham: " + e.getMessage(), e);
            }
        }
    }

    /**
     * Đảo trạng thái Đang bán (1) <-> Ngừng bán (0) và trả về giá trị MỚI.
     * Dùng cho công tắc (toggle switch) bật/tắt trên bảng danh sách: bấm 1 cái là đổi
     * ngay, không cần mở cả form sửa. Trả về null nếu không tìm thấy sản phẩm.
     * Dùng HQL UPDATE trực tiếp (bulk update) thay vì find() rồi merge() để nhanh gọn
     * và tránh nạp/no cache thực thể không cần thiết.
     */
    public Integer toggleTrangThai(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            SanPham sp = s.find(SanPham.class, id);
            if (sp == null) return null;
            int moi = (sp.getTrangThai() != null && sp.getTrangThai() == 1) ? 0 : 1;
            try {
                s.getTransaction().begin();
                s.createQuery("UPDATE SanPham SET trangThai = :tt WHERE id = :id")
                        .setParameter("tt", moi)
                        .setParameter("id", id)
                        .executeUpdate();
                s.getTransaction().commit();
            } catch (Exception e) {
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi doi trang thai san pham: " + e.getMessage(), e);
            }
            return moi;
        }
    }

    public void DeleteSanPham(SanPham SP){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.delete(SP);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi xoa san pham: " + e.getMessage(), e);
            }
        }
    }

    // Danh sách thuộc tính phục vụ form thêm/sửa sản phẩm
    public List<ThuongHieu> getAllThuongHieu(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from ThuongHieu ", ThuongHieu.class).list();
        }
    }
    public List<DanhMuc> getAllDanhMuc(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from DanhMuc ", DanhMuc.class).list();
        }
    }
    public List<ChatLieu> getAllChatLieu(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from ChatLieu ", ChatLieu.class).list();
        }
    }
    public List<KieuDang> getAllKieuDang(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from KieuDang ", KieuDang.class).list();
        }
    }

    public ThuongHieu getThuongHieu(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(ThuongHieu.class, id);
        }
    }
    public DanhMuc getDanhMuc(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(DanhMuc.class, id);
        }
    }
    public ChatLieu getChatLieu(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(ChatLieu.class, id);
        }
    }
    public KieuDang getKieuDang(Integer id){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(KieuDang.class, id);
        }
    }

    public static void main(String[] args) {
        System.out.println(new SanPhamResponsitory().getAll());
    }
}
