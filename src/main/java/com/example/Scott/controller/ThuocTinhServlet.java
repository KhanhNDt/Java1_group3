package com.example.Scott.controller;

import com.example.Scott.dto.ThuocTinhDTO;
import com.example.Scott.entity.*;
import com.example.Scott.responsitory.ThuocTinhResponsitory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "ThuocTinhServlet", value = {
        "/thuoc-tinh/hien-thi", "/thuoc-tinh/add", "/thuoc-tinh/update",
        "/thuoc-tinh/delete", "/thuoc-tinh/view-update"
})
public class ThuocTinhServlet extends HttpServlet {
    private final ThuocTinhResponsitory repository = new ThuocTinhResponsitory();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("view-update")) {
            viewUpdate(request, response);
        } else if (uri.contains("delete")) {
            delete(request, response);
        } else {
            hienThi(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("update")) {
            update(request, response);
        } else {
            add(request, response);
        }
    }

    private void hienThi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        render(request, response, null, false);
    }

    private void viewUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Config config = getConfig(request.getParameter("type"));
        Integer id = parseId(request.getParameter("id"));
        if (config == null || id == null) {
            flash(request, "error", "Dữ liệu thuộc tính không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/thuoc-tinh/hien-thi");
            return;
        }
        Object entity = repository.getOne(config.entityClass, id);
        if (entity == null) {
            flash(request, "error", "Không tìm thấy thuộc tính cần sửa.");
            response.sendRedirect(request.getContextPath() + "/thuoc-tinh/hien-thi?type=" + config.type);
            return;
        }
        render(request, response, toDTO(config, entity), true);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Config config = getConfig(request.getParameter("type"));
        ThuocTinhDTO form = readForm(request, null);
        String error = validate(config, form, null);
        if (error != null) {
            request.setAttribute("error", error);
            render(request, response, form, true);
            return;
        }
        try {
            repository.save(buildEntity(config, form, null));
            flash(request, "success", "Thêm " + config.label.toLowerCase() + " thành công.");
            response.sendRedirect(request.getContextPath() + "/thuoc-tinh/hien-thi?type=" + config.type);
        } catch (Exception e) {
            request.setAttribute("error", "Không thể thêm dữ liệu. Vui lòng kiểm tra ràng buộc và thử lại.");
            render(request, response, form, true);
        }
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Config config = getConfig(request.getParameter("type"));
        Integer id = parseId(request.getParameter("id"));
        ThuocTinhDTO form = readForm(request, id);
        String error = validate(config, form, id);
        if (error != null) {
            request.setAttribute("error", error);
            render(request, response, form, true);
            return;
        }
        Object current = repository.getOne(config.entityClass, id);
        if (current == null) {
            flash(request, "error", "Không tìm thấy dữ liệu cần cập nhật.");
            response.sendRedirect(request.getContextPath() + "/thuoc-tinh/hien-thi?type=" + config.type);
            return;
        }
        try {
            repository.update(buildEntity(config, form, current));
            flash(request, "success", "Cập nhật " + config.label.toLowerCase() + " thành công.");
            response.sendRedirect(request.getContextPath() + "/thuoc-tinh/hien-thi?type=" + config.type);
        } catch (Exception e) {
            request.setAttribute("error", "Không thể cập nhật dữ liệu. Vui lòng thử lại.");
            render(request, response, form, true);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Config config = getConfig(request.getParameter("type"));
        Integer id = parseId(request.getParameter("id"));
        if (config == null || id == null) {
            flash(request, "error", "Yêu cầu xóa không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/thuoc-tinh/hien-thi");
            return;
        }
        long references = repository.countReferences(config.type, id);
        if (references > 0) {
            flash(request, "error", "Không thể xóa vì thuộc tính đang được dùng bởi " + references + " sản phẩm/biến thể. ");
        } else {
            Object entity = repository.getOne(config.entityClass, id);
            if (entity == null) {
                flash(request, "error", "Không tìm thấy dữ liệu cần xóa.");
            } else {
                try {
                    repository.delete(entity);
                    flash(request, "success", "Xóa " + config.label.toLowerCase() + " thành công.");
                } catch (Exception e) {
                    flash(request, "error", "Không thể xóa do dữ liệu đang có liên kết.");
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/thuoc-tinh/hien-thi?type=" + config.type);
    }

    private void toggleTrangThai(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Config config = getConfig(request.getParameter("type"));
        Integer id = parseId(request.getParameter("id"));
        response.setContentType("application/json;charset=UTF-8");
        if (config == null || id == null) {
            response.setStatus(400);
            response.getWriter().write("{\"success\":false,\"message\":\"Dữ liệu không hợp lệ\"}");
            return;
        }
        Object entity = repository.getOne(config.entityClass, id);
        if (entity == null) {
            response.setStatus(404);
            response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy dữ liệu\"}");
            return;
        }
        int newStatus = getTrangThai(config, entity) == 1 ? 0 : 1;
        setTrangThai(config, entity, newStatus);
        repository.update(entity);
        response.getWriter().write("{\"success\":true,\"trangThai\":" + newStatus + "}");
    }

    private void render(HttpServletRequest request, HttpServletResponse response, ThuocTinhDTO form, boolean openModal)
            throws ServletException, IOException {
        Config config = getConfig(request.getParameter("type"));
        if (config == null) config = getConfig("danh-muc");
        String keyword = normalize(request.getParameter("keyword"));
        int page = positiveInt(request.getParameter("page"), 1);
        int size = positiveInt(request.getParameter("size"), 10);
        if (size != 10 && size != 20 && size != 50) size = 10;

        List<?> entities = repository.findAll(config.entityClass, config.tenField, keyword, null);
        List<ThuocTinhDTO> allRows = new ArrayList<ThuocTinhDTO>();
        for (Object entity : entities) allRows.add(toDTO(config, entity));
        int total = allRows.size();
        int totalPages = Math.max(1, (int) Math.ceil(total / (double) size));
        if (page > totalPages) page = totalPages;
        int from = Math.min((page - 1) * size, total);
        int to = Math.min(from + size, total);
        List<ThuocTinhDTO> rows = total == 0 ? Collections.<ThuocTinhDTO>emptyList() : allRows.subList(from, to);

        moveFlash(request);
        request.setAttribute("menu", "thuoctinh");
        request.setAttribute("type", config.type);
        request.setAttribute("typeLabel", config.label);
        request.setAttribute("hasCode", config.hasCode);
        request.setAttribute("hasDescription", config.hasDescription);
        request.setAttribute("listThuocTinh", rows);
        request.setAttribute("tongSoBanGhi", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", size);
        request.setAttribute("keyword", keyword);
        request.setAttribute("thuocTinhForm", form);
        request.setAttribute("openAttributeModal", openModal);
        request.getRequestDispatcher("/views/thuoctinh/index.jsp").forward(request, response);
    }

    private String validate(Config config, ThuocTinhDTO form, Integer excludeId) {
        if (config == null) return "Loại thuộc tính không hợp lệ.";
        if (form.getTen().length() < 2 || form.getTen().length() > 50) return "Tên thuộc tính phải từ 2 đến 50 ký tự.";
        if (!form.getTen().matches("^[\\p{L}0-9 ._&+\\-/]+$")) return "Tên thuộc tính chứa ký tự không hợp lệ.";
        if (repository.exists(config.entityClass, config.tenField, form.getTen(), excludeId)) return "Tên thuộc tính đã tồn tại.";
        if (config.hasCode) {
            if (form.getMa().length() < 2 || form.getMa().length() > 20) return "Mã thuộc tính phải từ 2 đến 20 ký tự.";
            if (!form.getMa().matches("^[A-Z0-9_-]+$")) return "Mã chỉ được gồm chữ in hoa, số, dấu gạch ngang hoặc gạch dưới.";
            if (repository.exists(config.entityClass, config.maField, form.getMa(), excludeId)) return "Mã thuộc tính đã tồn tại.";
        }
        if (config.hasDescription && form.getMoTa().length() > 255) return "Mô tả không được vượt quá 255 ký tự.";
        return null;
    }

    private ThuocTinhDTO readForm(HttpServletRequest request, Integer id) {
        ThuocTinhDTO dto = new ThuocTinhDTO();
        dto.setId(id);
        dto.setMa(normalize(request.getParameter("ma")).toUpperCase());
        dto.setTen(normalize(request.getParameter("ten")));
        dto.setMoTa(normalize(request.getParameter("moTa")));
        dto.setTrangThai(1);
        return dto;
    }

    private Object buildEntity(Config config, ThuocTinhDTO dto, Object current) {
        if ("danh-muc".equals(config.type)) {
            DanhMuc x = current == null ? new DanhMuc() : (DanhMuc) current;
            x.setMaDanhMuc(dto.getMa()); x.setTenDanhMuc(dto.getTen()); x.setTrangThai(1); return x;
        }
        if ("thuong-hieu".equals(config.type)) {
            ThuongHieu x = current == null ? new ThuongHieu() : (ThuongHieu) current;
            x.setMa(dto.getMa()); x.setTen(dto.getTen()); x.setMoTa(dto.getMoTa()); x.setTrangThai(1); return x;
        }
        if ("chat-lieu".equals(config.type)) {
            ChatLieu x = current == null ? new ChatLieu() : (ChatLieu) current;
            x.setTenChatLieu(dto.getTen()); x.setTrangThai(1); return x;
        }
        if ("kieu-dang".equals(config.type)) {
            KieuDang x = current == null ? new KieuDang() : (KieuDang) current;
            x.setTenKieuDang(dto.getTen()); x.setTrangThai(1); return x;
        }
        if ("mau-sac".equals(config.type)) {
            MauSac x = current == null ? new MauSac() : (MauSac) current;
            x.setMa(dto.getMa()); x.setTen(dto.getTen()); x.setTrangThai(1); return x;
        }
        Size x = current == null ? new Size() : (Size) current;
        x.setMa(dto.getMa()); x.setTen(dto.getTen()); x.setTrangThai(1); return x;
    }

    private ThuocTinhDTO toDTO(Config config, Object entity) {
        ThuocTinhDTO dto = new ThuocTinhDTO();
        if (entity instanceof DanhMuc) { DanhMuc x=(DanhMuc)entity; dto.setId(x.getId()); dto.setMa(x.getMaDanhMuc()); dto.setTen(x.getTenDanhMuc()); dto.setTrangThai(x.getTrangThai()); }
        else if (entity instanceof ThuongHieu) { ThuongHieu x=(ThuongHieu)entity; dto.setId(x.getId()); dto.setMa(x.getMa()); dto.setTen(x.getTen()); dto.setMoTa(x.getMoTa()); dto.setTrangThai(x.getTrangThai()); }
        else if (entity instanceof ChatLieu) { ChatLieu x=(ChatLieu)entity; dto.setId(x.getId()); dto.setTen(x.getTenChatLieu()); dto.setTrangThai(x.getTrangThai()); }
        else if (entity instanceof KieuDang) { KieuDang x=(KieuDang)entity; dto.setId(x.getId()); dto.setTen(x.getTenKieuDang()); dto.setTrangThai(x.getTrangThai()); }
        else if (entity instanceof MauSac) { MauSac x=(MauSac)entity; dto.setId(x.getId()); dto.setMa(x.getMa()); dto.setTen(x.getTen()); dto.setTrangThai(x.getTrangThai()); }
        else { Size x=(Size)entity; dto.setId(x.getId()); dto.setMa(x.getMa()); dto.setTen(x.getTen()); dto.setTrangThai(x.getTrangThai()); }
        dto.setSoLuongSuDung(repository.countReferences(config.type, dto.getId()));
        return dto;
    }

    private int getTrangThai(Config config, Object entity) { return toDTO(config, entity).getTrangThai() == null ? 0 : toDTO(config, entity).getTrangThai(); }
    private void setTrangThai(Config config, Object entity, int status) {
        if (entity instanceof DanhMuc) ((DanhMuc) entity).setTrangThai(status);
        else if (entity instanceof ThuongHieu) ((ThuongHieu) entity).setTrangThai(status);
        else if (entity instanceof ChatLieu) ((ChatLieu) entity).setTrangThai(status);
        else if (entity instanceof KieuDang) ((KieuDang) entity).setTrangThai(status);
        else if (entity instanceof MauSac) ((MauSac) entity).setTrangThai(status);
        else if (entity instanceof Size) ((Size) entity).setTrangThai(status);
    }

    private Config getConfig(String type) {
        if ("danh-muc".equals(type)) return new Config(type,"Danh mục",DanhMuc.class,"maDanhMuc","tenDanhMuc",true,false);
        if ("thuong-hieu".equals(type)) return new Config(type,"Thương hiệu",ThuongHieu.class,"ma","ten",true,true);
        if ("chat-lieu".equals(type)) return new Config(type,"Chất liệu",ChatLieu.class,null,"tenChatLieu",false,false);
        if ("kieu-dang".equals(type)) return new Config(type,"Kiểu dáng",KieuDang.class,null,"tenKieuDang",false,false);
        if ("mau-sac".equals(type)) return new Config(type,"Màu sắc",MauSac.class,"ma","ten",true,false);
        if ("size".equals(type)) return new Config(type,"Kích thước",Size.class,"ma","ten",true,false);
        return null;
    }

    private static class Config {
        private final String type, label, maField, tenField;
        private final Class entityClass;
        private final boolean hasCode, hasDescription;
        private Config(String type, String label, Class entityClass, String maField, String tenField, boolean hasCode, boolean hasDescription) {
            this.type=type; this.label=label; this.entityClass=entityClass; this.maField=maField; this.tenField=tenField; this.hasCode=hasCode; this.hasDescription=hasDescription;
        }
    }

    private String normalize(String value) { return value == null ? "" : value.trim().replaceAll("\\s+", " "); }
    private Integer parseId(String value) { try { int x=Integer.parseInt(value); return x>0?x:null; } catch(Exception e){ return null; } }
    private Integer parseStatus(String value) { if ("0".equals(value)) return 0; if ("1".equals(value)) return 1; return null; }
    private int positiveInt(String value, int fallback) { try { int x=Integer.parseInt(value); return x>0?x:fallback; } catch(Exception e){ return fallback; } }
    private void flash(HttpServletRequest request, String key, String value) { request.getSession().setAttribute(key, value); }
    private void moveFlash(HttpServletRequest request) {
        Object success=request.getSession().getAttribute("success"); Object error=request.getSession().getAttribute("error");
        if(success!=null){request.setAttribute("success",success);request.getSession().removeAttribute("success");}
        if(error!=null){request.setAttribute("error",error);request.getSession().removeAttribute("error");}
    }
}
