package com.example.Scott.responsitory;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class NhanVienRepository {


    public List<NhanVien> getAll() {

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            return session.createQuery("from NhanVien").list();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
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
            session.save(nv); // Lưu ý: Nếu có lỗi SQL nó sẽ ném ra tại đây
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw e; // NÉM LỖI RA ĐỂ XEM NÓ BÁO LỖI GÌ TRONG CONSOLE
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

            if (transaction != null) {
                transaction.rollback();
            }

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

            if (transaction != null) {
                transaction.rollback();
            }

            e.printStackTrace();
            return false;
        }
    }


    public NhanVien findByMa(String ma) {

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            Query query = session.createQuery(
                    "from NhanVien where maNhanVien = :ma"
            );

            query.setParameter("ma", ma);

            return (NhanVien) query.uniqueResult();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    public List<NhanVien> search(String keyword) {

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            if (keyword == null || keyword.trim().isEmpty()) {

                return session.createQuery("from NhanVien").list();
            }

            Query query = session.createQuery(
                    "from NhanVien " +
                            "where maNhanVien like :kw " +
                            "or hoTen like :kw"
            );

            query.setParameter("kw", "%" + keyword.trim() + "%");

            return query.list();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<NhanVien> getPage(int page, int size) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("from NhanVien", NhanVien.class)
                    .setFirstResult((page - 1) * size)
                    .setMaxResults(size)
                    .list();
        }
    }
    public static void main(String[] args) {
        System.out.println(new NhanVienRepository().getAll());
    }
}