package com.example.Scott.responsitory;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class NhanVienRepository {

    // Hiển thị tất cả
    public List<NhanVien> getAll() {
        Session session = HibernateConfig.getFACTORY().openSession();
        List<NhanVien> list = session.createQuery("from NhanVien", NhanVien.class).list();
        session.close();
        return list;
    }

    // Lấy theo ID
    public NhanVien getOne(Integer id) {
        Session session = HibernateConfig.getFACTORY().openSession();
        NhanVien nv = session.get(NhanVien.class, id);
        session.close();
        return nv;
    }

    // Thêm
    public boolean add(NhanVien nv) {
        Transaction transaction = null;

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            transaction = session.beginTransaction();

            session.persist(nv);

            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null) {
                transaction.rollback();
            }

            e.printStackTrace();

            return false;
        }
    }

    // Cập nhật
    public boolean update(NhanVien nv) {

        Transaction transaction = null;

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            transaction = session.beginTransaction();

            session.merge(nv);

            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null) {
                transaction.rollback();
            }

            e.printStackTrace();

            return false;
        }
    }

    // Xóa
    public boolean delete(Integer id) {

        Transaction transaction = null;

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            transaction = session.beginTransaction();

            NhanVien nv = session.get(NhanVien.class, id);

            if (nv != null) {
                session.remove(nv);
            }

            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null) {
                transaction.rollback();
            }

            e.printStackTrace();

            return false;
        }
    }


    public NhanVien findByMa(String ma) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Query<NhanVien> query = session.createQuery(
                "from NhanVien where maNhanVien = :ma",
                NhanVien.class
        );

        query.setParameter("ma", ma);

        NhanVien nv = query.uniqueResult();

        session.close();

        return nv;
    }

    // Tìm kiếm theo mã hoặc tên
    public List<NhanVien> search(String keyword) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Query<NhanVien> query = session.createQuery(
                "from NhanVien where maNhanVien like :kw or hoTen like :kw",
                NhanVien.class
        );

        query.setParameter("kw", "%" + keyword + "%");

        List<NhanVien> list = query.list();

        session.close();

        return list;
    }
}