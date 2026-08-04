package com.example.Scott.responsitory;

import com.example.Scott.entity.AnhMauSac;
import com.example.Scott.entity.MauSac;
import com.example.Scott.entity.SanPham;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

/**
 * Quản lý ảnh riêng theo màu sắc của sản phẩm (bảng anh_mau_sac).
 * Cùng nguyên tắc mở/đóng Session như các Responsitory khác trong project:
 * KHÔNG giữ Session sống lâu trong field, mỗi method tự mở và tự đóng.
 */
public class AnhMauSacResponsitory {

    /** Lấy toàn bộ ảnh theo màu của 1 sản phẩm, dạng Map(idMauSac -> đường dẫn ảnh) để dễ tra cứu khi hiển thị. */
    public Map<Integer, String> getMapAnhTheoSanPham(Integer idSanPham) {
        Map<Integer, String> result = new LinkedHashMap<>();
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            List<Object[]> rows = s.createQuery(
                    "SELECT am.mauSac.id, am.duongDanAnh FROM AnhMauSac am WHERE am.sanPham.id = :idSp",
                    Object[].class)
                    .setParameter("idSp", idSanPham)
                    .list();
            for (Object[] row : rows) {
                result.put((Integer) row[0], (String) row[1]);
            }
        }
        return result;
    }

    public AnhMauSac getBySanPhamVaMau(Integer idSanPham, Integer idMauSac) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            List<AnhMauSac> list = s.createQuery(
                    "FROM AnhMauSac WHERE sanPham.id = :idSp AND mauSac.id = :idMau",
                    AnhMauSac.class)
                    .setParameter("idSp", idSanPham)
                    .setParameter("idMau", idMauSac)
                    .list();
            return list.isEmpty() ? null : list.get(0);
        }
    }

    /**
     * Thêm mới hoặc cập nhật ảnh cho 1 cặp (sản phẩm, màu sắc).
     * Nhờ ràng buộc UNIQUE (id_san_pham, id_mau_sac) ở DB nên không sợ tạo trùng.
     */
    public void luuAnh(Integer idSanPham, Integer idMauSac, String duongDanAnh) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                AnhMauSac existing = s.createQuery(
                        "FROM AnhMauSac WHERE sanPham.id = :idSp AND mauSac.id = :idMau",
                        AnhMauSac.class)
                        .setParameter("idSp", idSanPham)
                        .setParameter("idMau", idMauSac)
                        .uniqueResultOptional().orElse(null);

                if (existing != null) {
                    existing.setDuongDanAnh(duongDanAnh);
                    s.merge(existing);
                } else {
                    AnhMauSac moi = AnhMauSac.builder()
                            .sanPham(s.getReference(SanPham.class, idSanPham))
                            .mauSac(s.getReference(MauSac.class, idMauSac))
                            .duongDanAnh(duongDanAnh)
                            .build();
                    s.persist(moi);
                }
                s.getTransaction().commit();
            } catch (Exception e) {
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi luu anh theo mau: " + e.getMessage(), e);
            }
        }
    }

    public void xoaAnh(Integer idSanPham, Integer idMauSac) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.createQuery("DELETE FROM AnhMauSac WHERE sanPham.id = :idSp AND mauSac.id = :idMau")
                        .setParameter("idSp", idSanPham)
                        .setParameter("idMau", idMauSac)
                        .executeUpdate();
                s.getTransaction().commit();
            } catch (Exception e) {
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi xoa anh theo mau: " + e.getMessage(), e);
            }
        }
    }
}
