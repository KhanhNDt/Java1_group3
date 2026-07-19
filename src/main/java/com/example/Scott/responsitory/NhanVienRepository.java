package com.example.Scott.responsitory;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

public class NhanVienRepository {

    public List<NhanVien> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("select nv from NhanVien nv order by nv.id desc", NhanVien.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public NhanVien getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.get(NhanVien.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean add(NhanVien nv) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.save(nv);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(NhanVien nv) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.update(nv);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(Integer id) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            NhanVien nv = session.get(NhanVien.class, id);
            if (nv != null) {
                session.delete(nv);
            }
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Đổi nhanh trạng thái Đang làm / Đã nghỉ (dùng cho công tắc gạt ở cột Hành động)
     */
    public boolean updateTrangThai(int id, int trangThai) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            NhanVien nv = session.get(NhanVien.class, id);
            if (nv != null) {
                nv.setTrangThai(trangThai);
                session.update(nv);
            }
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public NhanVien findByMa(String ma) {
        if (ma == null || ma.trim().isEmpty()) {
            return null;
        }
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Query<NhanVien> query = session.createQuery(
                    "select nv from NhanVien nv where nv.maNhanVien = :ma", NhanVien.class);
            query.setParameter("ma", ma.trim());
            query.setMaxResults(1); // tránh NonUniqueResultException nếu lỡ có 2 dòng trùng mã
            List<NhanVien> result = query.list();
            return result.isEmpty() ? null : result.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Lọc danh sách nhân viên theo từ khóa / chức vụ / trạng thái, có phân trang.
     *
     * @param keyword   tìm theo mã, họ tên, email, SĐT (có thể null/rỗng)
     * @param chucVu    lọc theo chức vụ (có thể null/rỗng = tất cả)
     * @param trangThai lọc theo trạng thái (null = tất cả, 1 = đang làm, 0 = đã nghỉ)
     * @param offset    vị trí bắt đầu (phân trang)
     * @param limit     số bản ghi mỗi trang
     */
    public List<NhanVien> filter(String keyword, String chucVu, Integer trangThai, int offset, int limit) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("select nv from NhanVien nv where 1=1");
            appendConditions(hql, keyword, chucVu, trangThai);
            hql.append(" order by nv.id desc");

            Query<NhanVien> query = session.createQuery(hql.toString(), NhanVien.class);
            bindParameters(query, keyword, chucVu, trangThai);
            query.setFirstResult(offset);
            query.setMaxResults(limit);

            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Đếm tổng số bản ghi khớp với bộ lọc (dùng để tính tổng số trang).
     */
    public long countFilter(String keyword, String chucVu, Integer trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("select count(nv.id) from NhanVien nv where 1=1");
            appendConditions(hql, keyword, chucVu, trangThai);

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            bindParameters(query, keyword, chucVu, trangThai);

            Long total = query.uniqueResult();
            return total == null ? 0L : total;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }

    private void appendConditions(StringBuilder hql, String keyword, String chucVu, Integer trangThai) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" and (lower(nv.maNhanVien) like :kw or lower(nv.hoTen) like :kw " +
                    "or lower(nv.email) like :kw or nv.soDienThoai like :kw)");
        }
        if (chucVu != null && !chucVu.trim().isEmpty()) {
            hql.append(" and nv.chucVu = :chucVu");
        }
        if (trangThai != null) {
            hql.append(" and nv.trangThai = :trangThai");
        }
    }

    private void bindParameters(Query<?> query, String keyword, String chucVu, Integer trangThai) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
        }
        if (chucVu != null && !chucVu.trim().isEmpty()) {
            query.setParameter("chucVu", chucVu);
        }
        if (trangThai != null) {
            query.setParameter("trangThai", trangThai);
        }
    }

    public static void main(String[] args) {
        System.out.println(new NhanVienRepository().getAll());
    }
}