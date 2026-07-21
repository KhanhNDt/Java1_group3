package com.example.Scott.controller;

import com.example.Scott.entity.ChiTietSanPham;
import com.example.Scott.entity.SanPham;
import com.example.Scott.responsitory.ChiTietSanPhamResponsitory;
import com.example.Scott.responsitory.SanPhamResponsitory;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
import java.util.Set;
import java.util.Locale;

@WebServlet(name = "SanPhamServlet", value = {
        "/san-pham/hien-thi",
        "/san-pham/them-moi",
        "/san-pham/add",
        "/san-pham/delete",
        "/san-pham/update",
        "/san-pham/view-update",
        "/san-pham/search",
        "/san-pham/goi-y",
        "/san-pham/toggle-trang-thai",
        "/san-pham/chi-tiet/toggle-trang-thai",
        "/san-pham/chi-tiet/hien-thi",
        "/san-pham/chi-tiet/add",
        "/san-pham/chi-tiet/update",
        "/san-pham/chi-tiet/view-update"
})
public class SanPhamServlet extends HttpServlet {

    private SanPhamResponsitory sanPhamResponsitory = new SanPhamResponsitory();
    private ChiTietSanPhamResponsitory chiTietSanPhamResponsitory = new ChiTietSanPhamResponsitory();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("them-moi")) {
            this.hienThiThemMoi(request, response);
        } else if (uri.contains("goi-y")) {
            this.goiYSanPham(request, response);
        } else if (uri.contains("chi-tiet/hien-thi")) {
            this.hienThiTatCaChiTiet(request, response);
        } else if (uri.contains("chi-tiet/view-update")) {
            this.viewUpdateChiTietSanPham(request, response);
        } else if (uri.contains("hien-thi")) {
            this.hienThiSanPham(request, response);
        } else if (uri.contains("delete")) {
            this.deleteSanPham(request, response);
        } else if (uri.contains("view-update")) {
            this.viewUpdateSanPham(request, response);
        } else {
            this.searchSanPham(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("chi-tiet/toggle-trang-thai")) {
            this.toggleTrangThaiChiTiet(request, response);
        } else if (uri.contains("toggle-trang-thai")) {
            this.toggleTrangThaiSanPham(request, response);
        } else if (uri.contains("chi-tiet/add")) {
            this.addChiTietSanPham(request, response);
        } else if (uri.contains("chi-tiet/update")) {
            this.updateChiTietSanPham(request, response);
        } else if (uri.contains("add")) {
            this.addSanPham(request, response);
        } else {
            this.updateSanPham(request, response);
        }
    }

    // ================= SẢN PHẨM =================

    private void hienThiThemMoi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "sanpham");
        request.setAttribute("submenu", "danhsach");
        loadThuocTinh(request);
        moveFlash(request);
        request.getRequestDispatcher("/views/sanpham/add.jsp").forward(request, response);
    }

    private void hienThiSanPham(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "sanpham");
        request.setAttribute("submenu", "danhsach");
        loadThuocTinh(request);

        // Đọc từ khóa trực tiếp từ request. Trước đây truyền null nên request AJAX
        // vẫn tải lại toàn bộ danh sách dù ô tìm kiếm đã có nội dung.
        String keyword = normalize(request.getParameter("keyword"));
        request.setAttribute("keyword", keyword);
        loadDanhSachPhanTrang(request, keyword);

        String selectedId = request.getParameter("selectedId");
        if (selectedId != null && !selectedId.isEmpty()) {
            Integer id = Integer.valueOf(selectedId);
            request.setAttribute("selectedSanPham", sanPhamResponsitory.getOne(id));
            request.setAttribute("listChiTiet", chiTietSanPhamResponsitory.getBySanPham(id));
        }
        moveFlash(request);
        request.getRequestDispatcher("/views/sanpham/index.jsp").forward(request, response);
    }


    private void goiYSanPham(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = normalize(request.getParameter("keyword"));
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        if (keyword.length() < 1) {
            result.put("items", new ArrayList<>());
        } else {
            result.put("items", sanPhamResponsitory.getGoiYTimKiem(keyword, 10));
        }
        response.getWriter().write(new Gson().toJson(result));
    }

    private void searchSanPham(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        request.setAttribute("menu", "sanpham");
        request.setAttribute("submenu", "danhsach");
        request.setAttribute("keyword", keyword);
        loadThuocTinh(request);
        loadDanhSachPhanTrang(request, keyword);
        moveFlash(request);
        request.getRequestDispatcher("/views/sanpham/index.jsp").forward(request, response);
    }

    private void viewUpdateSanPham(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "sanpham");
        request.setAttribute("submenu", "danhsach");
        Integer id = Integer.valueOf(request.getParameter("id"));
        loadThuocTinh(request);
        loadDanhSachPhanTrang(request, null);
        request.setAttribute("sanPhamForm", sanPhamResponsitory.getOne(id));
        request.setAttribute("selectedSanPham", sanPhamResponsitory.getOne(id));
        request.setAttribute("listChiTiet", chiTietSanPhamResponsitory.getBySanPham(id));
        moveFlash(request);
        request.getRequestDispatcher("/views/sanpham/index.jsp").forward(request, response);
    }

    private void addSanPham(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder loi = validateSanPhamRequest(request, null);

        String[] mauValues = request.getParameterValues("variantMauSac");
        String[] sizeValues = request.getParameterValues("variantSize");
        String[] giaNhapValues = request.getParameterValues("variantGiaNhap");
        String[] giaBanValues = request.getParameterValues("variantGiaBan");
        String[] soLuongValues = request.getParameterValues("variantSoLuongTon");

        int rowCount = mauValues == null ? 0 : mauValues.length;
        if (rowCount == 0) {
            loi.append("Sản phẩm bắt buộc phải có ít nhất một biến thể. ");
        } else if (rowCount > 100) {
            loi.append("Mỗi lần chỉ được tạo tối đa 100 biến thể. ");
        } else if (sizeValues == null || giaNhapValues == null || giaBanValues == null || soLuongValues == null
                || sizeValues.length != rowCount || giaNhapValues.length != rowCount
                || giaBanValues.length != rowCount || soLuongValues.length != rowCount) {
            loi.append("Dữ liệu biến thể không đầy đủ hoặc số cột không khớp nhau. ");
        }

        // Không dựng entity khi thông tin sản phẩm/khung dữ liệu biến thể còn sai,
        // tránh NumberFormatException do select bắt buộc đang rỗng.
        if (loi.length() > 0) {
            renderProductFormError(request, response, "Không thể thêm sản phẩm. " + loi);
            return;
        }

        SanPham sp = buildSanPhamFromRequest(request, new SanPham());
        sp.setMaSanPham(sanPhamResponsitory.generateNextMaSanPham());
        List<ChiTietSanPham> bienTheList = new ArrayList<>();
        Set<String> combinations = new HashSet<>();
        Set<String> codes = new HashSet<>();

        if (rowCount > 0 && loi.length() == 0) {
            for (int i = 0; i < rowCount; i++) {
                Integer idMau = parseInt(mauValues[i], "Màu biến thể dòng " + (i + 1), loi);
                Integer idSize = parseInt(sizeValues[i], "Size biến thể dòng " + (i + 1), loi);
                BigDecimal giaNhap = parseMoney(giaNhapValues[i], "Giá nhập dòng " + (i + 1), loi);
                BigDecimal giaBan = parseMoney(giaBanValues[i], "Giá bán dòng " + (i + 1), loi);
                Integer soLuong = parseInt(soLuongValues[i], "Số lượng dòng " + (i + 1), loi);

                com.example.Scott.entity.MauSac mau = idMau == null ? null : chiTietSanPhamResponsitory.getMauSac(idMau);
                com.example.Scott.entity.Size size = idSize == null ? null : chiTietSanPhamResponsitory.getSize(idSize);
                if (idMau != null && mau == null) loi.append("Màu ở dòng ").append(i + 1).append(" không tồn tại. ");
                if (idSize != null && size == null) loi.append("Size ở dòng ").append(i + 1).append(" không tồn tại. ");
                if (giaNhap != null && giaNhap.compareTo(BigDecimal.ZERO) < 0) loi.append("Giá nhập dòng ").append(i + 1).append(" không được âm. ");
                if (giaBan != null && giaBan.compareTo(BigDecimal.ZERO) < 0) loi.append("Giá bán dòng ").append(i + 1).append(" không được âm. ");
                if (giaNhap != null && giaBan != null && giaBan.compareTo(giaNhap) < 0) loi.append("Giá bán dòng ").append(i + 1).append(" phải lớn hơn hoặc bằng giá nhập. ");
                if (soLuong != null && soLuong < 0) loi.append("Số lượng dòng ").append(i + 1).append(" không được âm. ");

                if (mau != null && size != null && giaNhap != null && giaBan != null && soLuong != null) {
                    String combination = idMau + "-" + idSize;
                    if (!combinations.add(combination)) {
                        loi.append("Biến thể dòng ").append(i + 1).append(" bị trùng màu và size với dòng trước. ");
                        continue;
                    }
                    String maGoc = taoMaBienThe(sp, mau, size);
                    String ma = maGoc;
                    int suffix = 2;
                    while (chiTietSanPhamResponsitory.existsMa(ma, null) || codes.contains(ma)) {
                        String duoi = "-" + suffix++;
                        ma = gioiHanMa(maGoc, Math.max(1, 50 - duoi.length())) + duoi;
                    }
                    codes.add(ma);

                    ChiTietSanPham ct = new ChiTietSanPham();
                    ct.setMauSac(mau);
                    ct.setSize(size);
                    ct.setMa(ma);
                    ct.setGiaNhap(giaNhap);
                    ct.setGiaBan(giaBan);
                    ct.setSoLuongTon(soLuong);
                    ct.setTrangThai(1);
                    bienTheList.add(ct);
                }
            }
        }

        if (loi.length() > 0 || bienTheList.isEmpty()) {
            if (bienTheList.isEmpty() && loi.length() == 0) loi.append("Sản phẩm phải có ít nhất một biến thể hợp lệ. ");
            renderProductFormError(request, response, "Không thể thêm sản phẩm. " + loi);
            return;
        }

        try {
            sanPhamResponsitory.addSanPhamKemBienThe(sp, bienTheList);
            request.getSession().setAttribute("success", "Đã thêm sản phẩm " + sp.getMaSanPham() + " cùng " + bienTheList.size() + " biến thể.");
            response.sendRedirect(request.getContextPath() + "/san-pham/chi-tiet/hien-thi?idSanPham=" + sp.getId());
        } catch (Exception e) {
            renderProductFormError(request, response,
                    "Không thể thêm sản phẩm và biến thể. Toàn bộ dữ liệu đã được hoàn tác: " + rootMessage(e));
        }
    }

    private void updateSanPham(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer id = parseIntOrNull(request.getParameter("id"));
        if (id == null || sanPhamResponsitory.getOne(id) == null) {
            request.getSession().setAttribute("error", "Sản phẩm cần cập nhật không tồn tại.");
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi");
            return;
        }

        StringBuilder loi = validateSanPhamRequest(request, id);
        if (loi.length() > 0) {
            request.setAttribute("sanPhamForm", sanPhamResponsitory.getOne(id));
            renderProductFormError(request, response, "Không thể cập nhật sản phẩm. " + loi);
            return;
        }

        SanPham sp = buildSanPhamFromRequest(request, sanPhamResponsitory.getOne(id));
        try {
            sanPhamResponsitory.updateSanPham(sp);
            request.getSession().setAttribute("success", "Đã cập nhật sản phẩm " + sp.getMaSanPham() + ".");
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + id);
        } catch (Exception e) {
            request.setAttribute("sanPhamForm", sp);
            renderProductFormError(request, response, "Không thể cập nhật sản phẩm do dữ liệu hoặc cơ sở dữ liệu không hợp lệ.");
        }
    }

    private StringBuilder validateSanPhamRequest(HttpServletRequest request, Integer excludeId) {
        StringBuilder loi = new StringBuilder();
        String ten = normalize(request.getParameter("tenSanPham"));
        String moTa = normalize(request.getParameter("moTa"));

        if (ten.length() < 3 || ten.length() > 100) loi.append("Tên sản phẩm phải từ 3 đến 100 ký tự. ");
        if (moTa.length() > 500) loi.append("Mô tả không được vượt quá 500 ký tự. ");

        String gioiTinh = request.getParameter("gioiTinh");
        String trangThai = request.getParameter("trangThai");
        if (!("0".equals(gioiTinh) || "1".equals(gioiTinh))) loi.append("Giới tính không hợp lệ. ");
        if (!("0".equals(trangThai) || "1".equals(trangThai))) loi.append("Trạng thái không hợp lệ. ");

        Integer idThuongHieu = parseIntOrNull(request.getParameter("idThuongHieu"));
        Integer idDanhMuc = parseIntOrNull(request.getParameter("idDanhMuc"));
        Integer idChatLieu = parseIntOrNull(request.getParameter("idChatLieu"));
        Integer idKieuDang = parseIntOrNull(request.getParameter("idKieuDang"));
        if (idThuongHieu == null || sanPhamResponsitory.getThuongHieu(idThuongHieu) == null) loi.append("Hãy chọn thương hiệu hợp lệ. ");
        if (idDanhMuc == null || sanPhamResponsitory.getDanhMuc(idDanhMuc) == null) loi.append("Hãy chọn danh mục hợp lệ. ");
        if (idChatLieu == null || sanPhamResponsitory.getChatLieu(idChatLieu) == null) loi.append("Hãy chọn chất liệu hợp lệ. ");
        if (idKieuDang == null || sanPhamResponsitory.getKieuDang(idKieuDang) == null) loi.append("Hãy chọn kiểu dáng hợp lệ. ");
        return loi;
    }

    private SanPham buildSanPhamFromRequest(HttpServletRequest request, SanPham sp) {
        // Khi cập nhật, giữ nguyên mã đã sinh; khi thêm mới mã được gán ngay trước khi lưu.
        sp.setTenSanPham(normalize(request.getParameter("tenSanPham")));
        sp.setMoTa(normalize(request.getParameter("moTa")));
        sp.setGioiTinh("1".equals(request.getParameter("gioiTinh")));
        sp.setTrangThai(Integer.valueOf(request.getParameter("trangThai")));
        sp.setThuongHieu(sanPhamResponsitory.getThuongHieu(Integer.valueOf(request.getParameter("idThuongHieu"))));
        sp.setDanhMuc(sanPhamResponsitory.getDanhMuc(Integer.valueOf(request.getParameter("idDanhMuc"))));
        sp.setChatLieu(sanPhamResponsitory.getChatLieu(Integer.valueOf(request.getParameter("idChatLieu"))));
        sp.setKieuDang(sanPhamResponsitory.getKieuDang(Integer.valueOf(request.getParameter("idKieuDang"))));
        return sp;
    }

    private void renderProductFormError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("menu", "sanpham");
        request.setAttribute("submenu", "danhsach");
        request.setAttribute("error", message);
        loadThuocTinh(request);
        request.getRequestDispatcher("/views/sanpham/add.jsp").forward(request, response);
    }

    private String rootMessage(Throwable error) {
        if (error == null) return "Lỗi không xác định.";
        Throwable root = error;
        while (root.getCause() != null && root.getCause() != root) root = root.getCause();
        String message = root.getMessage();
        return message == null || message.trim().isEmpty() ? root.getClass().getSimpleName() : message;
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim().replaceAll("\\s+", " ");
    }

    private void deleteSanPham(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder loi = new StringBuilder();
        Integer id = parseInt(request.getParameter("id"), "Sản phẩm (id)", loi);
        if (id == null) {
            request.getSession().setAttribute("error", "Xóa sản phẩm thất bại: " + loi);
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi");
            return;
        }
        if (!chiTietSanPhamResponsitory.getBySanPham(id).isEmpty()) {
            request.getSession().setAttribute("error", "Không thể xóa sản phẩm đang có biến thể. Hãy xóa biến thể trước.");
        } else {
            try {
                SanPham SP = sanPhamResponsitory.getOne(id);
                sanPhamResponsitory.DeleteSanPham(SP);
                request.getSession().setAttribute("success", "Xóa sản phẩm thành công.");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Xóa sản phẩm thất bại: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi");
    }

    // ================= CHI TIẾT SẢN PHẨM (BIẾN THỂ) =================

    private void viewUpdateChiTietSanPham(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "sanpham");
        request.setAttribute("submenu", "danhsach");
        Integer id = Integer.valueOf(request.getParameter("id"));
        ChiTietSanPham CT = chiTietSanPhamResponsitory.getOne(id);
        loadThuocTinh(request);
        request.setAttribute("chiTietForm", CT);
        moveFlash(request);
        request.getRequestDispatcher("/views/sanpham/edit-variant.jsp").forward(request, response);
    }

    private void addChiTietSanPham(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder loi = new StringBuilder();
        Integer idSanPham = parseInt(request.getParameter("idSanPham"), "Sản phẩm", loi);
        if (idSanPham == null || sanPhamResponsitory.getOne(idSanPham) == null) {
            request.getSession().setAttribute("error", "Thêm biến thể thất bại: Sản phẩm không tồn tại.");
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi");
            return;
        }

        String[] mauValues = request.getParameterValues("idMauSac");
        String[] sizeValues = request.getParameterValues("idSize");
        if (mauValues == null || mauValues.length == 0) loi.append("Phải chọn ít nhất một màu sắc. ");
        if (sizeValues == null || sizeValues.length == 0) loi.append("Phải chọn ít nhất một size. ");

        Integer soLuongTon = parseInt(request.getParameter("soLuongTon"), "Tồn kho", loi);
        BigDecimal giaNhap = parseMoney(request.getParameter("giaNhap"), "Giá nhập", loi);
        BigDecimal giaBan = parseMoney(request.getParameter("giaBan"), "Giá bán", loi);

        if (soLuongTon != null && soLuongTon < 0) loi.append("Tồn kho không được âm. ");
        if (giaNhap != null && giaNhap.compareTo(BigDecimal.ZERO) < 0) loi.append("Giá nhập không được âm. ");
        if (giaBan != null && giaBan.compareTo(BigDecimal.ZERO) < 0) loi.append("Giá bán không được âm. ");
        if (giaNhap != null && giaBan != null && giaBan.compareTo(giaNhap) < 0) {
            loi.append("Giá bán không được nhỏ hơn giá nhập. ");
        }

        List<Integer> mauIds = parseDistinctIds(mauValues, "Màu sắc", loi);
        List<Integer> sizeIds = parseDistinctIds(sizeValues, "Size", loi);
        int soToHop = mauIds.size() * sizeIds.size();
        if (soToHop > 100) loi.append("Mỗi lần chỉ được tạo tối đa 100 biến thể. ");

        if (loi.length() > 0) {
            request.getSession().setAttribute("error", "Thêm biến thể thất bại: " + loi);
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + idSanPham);
            return;
        }

        SanPham sanPham = sanPhamResponsitory.getOne(idSanPham);
        List<ChiTietSanPham> danhSachMoi = new ArrayList<>();
        int boQua = 0;
        Set<String> maTrongLo = new HashSet<>();

        for (Integer idMau : mauIds) {
            com.example.Scott.entity.MauSac mau = chiTietSanPhamResponsitory.getMauSac(idMau);
            if (mau == null) {
                loi.append("Màu sắc id ").append(idMau).append(" không tồn tại. ");
                continue;
            }
            for (Integer idSize : sizeIds) {
                com.example.Scott.entity.Size size = chiTietSanPhamResponsitory.getSize(idSize);
                if (size == null) {
                    loi.append("Size id ").append(idSize).append(" không tồn tại. ");
                    continue;
                }
                if (chiTietSanPhamResponsitory.existsCombination(idSanPham, idMau, idSize, null)) {
                    boQua++;
                    continue;
                }

                String ma = taoMaBienThe(sanPham, mau, size);
                String maGoc = ma;
                int suffix = 2;
                while (chiTietSanPhamResponsitory.existsMa(ma, null) || maTrongLo.contains(ma)) {
                    ma = maGoc + "-" + suffix++;
                }
                maTrongLo.add(ma);

                ChiTietSanPham ct = new ChiTietSanPham();
                ct.setSanPham(sanPham);
                ct.setMauSac(mau);
                ct.setSize(size);
                ct.setMa(ma);
                ct.setGiaNhap(giaNhap);
                ct.setGiaBan(giaBan);
                ct.setSoLuongTon(soLuongTon);
                ct.setTrangThai(1); // trạng thái nội bộ mặc định; không hiển thị trên giao diện
                danhSachMoi.add(ct);
            }
        }

        if (loi.length() > 0) {
            request.getSession().setAttribute("error", "Thêm biến thể thất bại: " + loi);
        } else if (danhSachMoi.isEmpty()) {
            request.getSession().setAttribute("error", "Không có biến thể mới. Các tổ hợp màu và size đã tồn tại.");
        } else {
            try {
                chiTietSanPhamResponsitory.addMany(danhSachMoi);
                String message = "Đã thêm " + danhSachMoi.size() + " biến thể thành công.";
                if (boQua > 0) message += " Bỏ qua " + boQua + " tổ hợp đã tồn tại.";
                request.getSession().setAttribute("success", message);
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Thêm biến thể thất bại. Toàn bộ lô đã được hoàn tác: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + idSanPham);
    }

    private List<Integer> parseDistinctIds(String[] values, String label, StringBuilder loi) {
        List<Integer> result = new ArrayList<>();
        Set<Integer> seen = new HashSet<>();
        if (values == null) return result;
        for (String value : values) {
            Integer id = parseInt(value, label, loi);
            if (id != null && seen.add(id)) result.add(id);
        }
        return result;
    }

    private String taoMaBienThe(SanPham sp, com.example.Scott.entity.MauSac mau, com.example.Scott.entity.Size size) {
        String maSp = chuanHoaMa(sp.getMaSanPham());
        String maMau = chuanHoaMa(mau.getMa() != null && !mau.getMa().trim().isEmpty() ? mau.getMa() : mau.getTen());
        String maSize = chuanHoaMa(size.getMa() != null && !size.getMa().trim().isEmpty() ? size.getMa() : size.getTen());
        return gioiHanMa(maSp + "-" + maMau + "-" + maSize, 50);
    }

    private String chuanHoaMa(String value) {
        if (value == null) return "NA";
        String result = java.text.Normalizer.normalize(value, java.text.Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toUpperCase(Locale.ROOT)
                .replaceAll("[^A-Z0-9]+", "-")
                .replaceAll("(^-+|-+$)", "");
        return result.isEmpty() ? "NA" : result;
    }

    private String gioiHanMa(String value, int max) {
        return value.length() <= max ? value : value.substring(0, max);
    }

    private void updateChiTietSanPham(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder loi = new StringBuilder();
        Integer id = parseInt(request.getParameter("id"), "Mã biến thể (id)", loi);
        Integer idSanPham = parseInt(request.getParameter("idSanPham"), "Sản phẩm", loi);
        if (id == null || idSanPham == null) {
            request.getSession().setAttribute("error", "Cập nhật biến thể thất bại: " + loi);
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi" + (idSanPham != null ? "?selectedId=" + idSanPham : ""));
            return;
        }

        String ma = request.getParameter("maChiTiet");
        if (chiTietSanPhamResponsitory.existsMa(ma, id)) {
            request.getSession().setAttribute("error", "Mã biến thể đã tồn tại.");
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + idSanPham);
            return;
        }

        Integer idMauSac = parseInt(request.getParameter("idMauSac"), "Màu sắc", loi);
        Integer idSize = parseInt(request.getParameter("idSize"), "Size", loi);
        if (idMauSac != null && idSize != null &&
                chiTietSanPhamResponsitory.existsCombination(idSanPham, idMauSac, idSize, id)) {
            loi.append("Tổ hợp màu và size này đã tồn tại trong sản phẩm. ");
        }
        Integer soLuongTon = parseInt(request.getParameter("soLuongTon"), "Tồn kho", loi);
        BigDecimal giaNhap = parseMoney(request.getParameter("giaNhap"), "Giá nhập", loi);
        BigDecimal giaBan = parseMoney(request.getParameter("giaBan"), "Giá bán", loi);

        if (loi.length() > 0) {
            request.getSession().setAttribute("error", "Cập nhật biến thể thất bại: " + loi);
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + idSanPham);
            return;
        }
        if (giaBan.compareTo(giaNhap) < 0) {
            request.getSession().setAttribute("error", "Cập nhật biến thể thất bại: Giá bán không được nhỏ hơn giá nhập.");
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + idSanPham);
            return;
        }

        ChiTietSanPham CT = chiTietSanPhamResponsitory.getOne(id);
        CT.setMa(ma);
        CT.setMauSac(chiTietSanPhamResponsitory.getMauSac(idMauSac));
        CT.setSize(chiTietSanPhamResponsitory.getSize(idSize));
        CT.setGiaNhap(giaNhap);
        CT.setGiaBan(giaBan);
        CT.setSoLuongTon(soLuongTon);

        try {
            chiTietSanPhamResponsitory.updateChiTietSanPham(CT);
            request.getSession().setAttribute("success", "Cập nhật biến thể thành công.");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Cập nhật biến thể thất bại: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + idSanPham);
    }


    private void hienThiTatCaChiTiet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "sanpham");
        request.setAttribute("submenu", "bienthe");
        loadThuocTinh(request);

        String keyword = normalize(request.getParameter("keyword"));
        Integer idSanPham = parseIntOrNull(request.getParameter("idSanPham"));
        Integer idMauSac = parseIntOrNull(request.getParameter("idMauSac"));
        Integer idSize = parseIntOrNull(request.getParameter("idSize"));
        Integer trangThai = parseIntOrNull(request.getParameter("trangThai"));
        String tonKho = normalize(request.getParameter("tonKho"));
        String soLuong = normalize(request.getParameter("soLuong"));
        BigDecimal giaToiDa = parseMoneyOrNull(request.getParameter("giaToiDa"));
        int page = parsePageParam(request.getParameter("page"), 1);
        int pageSize = parsePageParam(request.getParameter("size"), 10);

        long total = chiTietSanPhamResponsitory.countPage(keyword, idSanPham, idMauSac, idSize, tonKho, soLuong, trangThai, giaToiDa);
        int totalPages = (int) Math.max(1, Math.ceil(total / (double) pageSize));
        if (page > totalPages) page = totalPages;

        request.setAttribute("listAllChiTiet", chiTietSanPhamResponsitory.getPage(
                keyword, idSanPham, idMauSac, idSize, tonKho, soLuong, trangThai, giaToiDa, page, pageSize));
        request.setAttribute("listSanPham", sanPhamResponsitory.getAll());
        request.setAttribute("keyword", keyword);
        request.setAttribute("idSanPham", idSanPham);
        request.setAttribute("idMauSac", idMauSac);
        request.setAttribute("idSize", idSize);
        request.setAttribute("trangThai", trangThai);
        request.setAttribute("tonKho", tonKho);
        request.setAttribute("soLuong", soLuong);
        request.setAttribute("giaToiDa", giaToiDa);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("tongSoTrang", totalPages);
        request.setAttribute("tongSoBienThe", total);
        moveFlash(request);
        request.getRequestDispatcher("/views/sanpham/chitiet-list.jsp").forward(request, response);
    }

    // ================= TOGGLE TRẠNG THÁI (AJAX) =================
    // Hai hàm dưới đây phục vụ công tắc bật/tắt (toggle switch) "Đang bán / Ngừng bán"
    // trên bảng danh sách: front-end gọi fetch() POST tới đây, KHÔNG reload cả trang,
    // server chỉ trả về 1 đoạn JSON nhỏ (thành công hay không + trạng thái mới) để
    // JS cập nhật lại đúng chữ/màu công tắc đó. Đây là lý do response không forward
    // sang JSP mà ghi thẳng JSON vào response.

    private void toggleTrangThaiSanPham(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = parseInt(request.getParameter("id"), "Sản phẩm (id)", new StringBuilder());
        if (id == null) {
            writeJson(response, false, "Thiếu id sản phẩm.", null);
            return;
        }
        try {
            Integer trangThaiMoi = sanPhamResponsitory.toggleTrangThai(id);
            if (trangThaiMoi == null) {
                writeJson(response, false, "Không tìm thấy sản phẩm.", null);
                return;
            }
            writeJson(response, true, trangThaiMoi == 1 ? "Đang bán" : "Ngừng bán", trangThaiMoi);
        } catch (Exception e) {
            writeJson(response, false, "Đổi trạng thái thất bại: " + e.getMessage(), null);
        }
    }


    private void toggleTrangThaiChiTiet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = parseInt(request.getParameter("id"), "Biến thể (id)", new StringBuilder());
        if (id == null) {
            writeJson(response, false, "Thiếu id biến thể.", null);
            return;
        }
        try {
            Integer trangThaiMoi = chiTietSanPhamResponsitory.toggleTrangThai(id);
            if (trangThaiMoi == null) {
                writeJson(response, false, "Không tìm thấy biến thể.", null);
                return;
            }
            writeJson(response, true, trangThaiMoi == 1 ? "Còn bán" : "Ngừng bán", trangThaiMoi);
        } catch (Exception e) {
            writeJson(response, false, "Đổi trạng thái thất bại: " + e.getMessage(), null);
        }
    }

    /** Ghi 1 object JSON {success, message, trangThai} ra response — dùng chung cho các endpoint AJAX. */
    private void writeJson(HttpServletResponse response, boolean success, String message, Integer trangThai) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("success", success);
        data.put("message", message);
        data.put("trangThai", trangThai);
        response.getWriter().write(new Gson().toJson(data));
    }

    // ================= HELPER =================

    private void loadThuocTinh(HttpServletRequest request) {
        request.setAttribute("listThuongHieu", sanPhamResponsitory.getAllThuongHieu());
        request.setAttribute("listDanhMuc", sanPhamResponsitory.getAllDanhMuc());
        request.setAttribute("listChatLieu", sanPhamResponsitory.getAllChatLieu());
        request.setAttribute("listKieuDang", sanPhamResponsitory.getAllKieuDang());
        request.setAttribute("listMauSac", chiTietSanPhamResponsitory.getAllMauSac());
        request.setAttribute("listSize", chiTietSanPhamResponsitory.getAllSize());
    }

    private void loadDanhSachPhanTrang(HttpServletRequest request, String keyword) {
        int page = parsePageParam(request.getParameter("page"), 1);
        int pageSize = parsePageParam(request.getParameter("size"), 10);

        // Bộ lọc nâng cao: đọc thẳng từ request (không cần truyền qua tham số method)
        // để MỌI nơi gọi loadDanhSachPhanTrang (hiển thị, tìm kiếm, xem/sửa...) đều tự
        // động áp dụng lọc nếu URL có sẵn các query-param này (?locDanhMuc=..&locThuongHieu=..).
        Integer idDanhMuc = parseIntOrNull(request.getParameter("locDanhMuc"));
        Integer idThuongHieu = parseIntOrNull(request.getParameter("locThuongHieu"));
        Integer trangThaiLoc = parseIntOrNull(request.getParameter("locTrangThai"));
        String sapXep = normalizeSort(request.getParameter("sapXep"));

        long tongSo = sanPhamResponsitory.countDanhSach(keyword, idDanhMuc, idThuongHieu, trangThaiLoc);
        int tongSoTrang = (int) Math.max(1, Math.ceil(tongSo / (double) pageSize));
        // Nếu đang đứng ở trang lớn hơn tổng số trang thực tế (VD: vừa xóa hết sản phẩm
        // ở trang cuối) thì kéo về trang cuối cùng còn dữ liệu, tránh hiển thị bảng trống.
        if (page > tongSoTrang) page = tongSoTrang;

        request.setAttribute("listSanPhamView",
                sanPhamResponsitory.getPageDanhSach(keyword, idDanhMuc, idThuongHieu, trangThaiLoc, sapXep, page, pageSize));
        request.setAttribute("tongSoSanPham", tongSo);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("tongSoTrang", tongSoTrang);

        // Trả các lựa chọn lọc hiện tại về lại JSP để form tự chọn đúng option
        // (không bị "quên" lựa chọn sau khi submit hoặc chuyển trang).
        request.setAttribute("locDanhMuc", idDanhMuc);
        request.setAttribute("locThuongHieu", idThuongHieu);
        request.setAttribute("locTrangThai", trangThaiLoc);
        request.setAttribute("sapXep", sapXep);
    }

    private String normalizeSort(String raw) {
        if (raw == null) return "mac-dinh";
        switch (raw) {
            case "ten-az": case "ten-za": case "gia-thap": case "gia-cao": case "moi-nhat":
                return raw;
            default:
                return "mac-dinh";
        }
    }

    /** Parse Integer an toàn, không ghi lỗi — dùng cho tham số LỌC không bắt buộc (rỗng = không lọc). */
    private Integer parseIntOrNull(String raw) {
        if (raw == null || raw.trim().isEmpty()) return null;
        try {
            return Integer.valueOf(raw.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /** Parse số trang/số dòng an toàn: rỗng hoặc sai định dạng -> dùng giá trị mặc định thay vì crash. */
    private int parsePageParam(String raw, int defaultValue) {
        if (raw == null || raw.trim().isEmpty()) return defaultValue;
        try {
            int v = Integer.parseInt(raw.trim());
            return v > 0 ? v : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private void moveFlash(HttpServletRequest request) {
        Object success = request.getSession().getAttribute("success");
        Object error = request.getSession().getAttribute("error");
        if (success != null) { request.setAttribute("success", success); request.getSession().removeAttribute("success"); }
        if (error != null) { request.setAttribute("error", error); request.getSession().removeAttribute("error"); }
    }

    /**
     * Parse an Integer an toàn từ request parameter.
     * Nếu rỗng hoặc sai định dạng -> trả về null và ghi lý do vào "loi" thay vì
     * ném NumberFormatException (nguyên nhân phổ biến khiến add/sửa/xóa "không chạy"
     * mà chỉ hiện trang lỗi trắng của Tomcat).
     */
    private Integer parseInt(String raw, String tenTruong, StringBuilder loi) {
        if (raw == null || raw.trim().isEmpty()) {
            loi.append("Chưa chọn/nhập " + tenTruong + ". ");
            return null;
        }
        try {
            return Integer.valueOf(raw.trim());
        } catch (NumberFormatException e) {
            loi.append(tenTruong + " không hợp lệ. ");
            return null;
        }
    }

    private BigDecimal parseMoneyOrNull(String raw) {
        if (raw == null || raw.trim().isEmpty()) return null;
        try {
            BigDecimal value = new BigDecimal(raw.trim().replace(",", ""));
            return value.compareTo(BigDecimal.ZERO) < 0 ? null : value;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /** Parse BigDecimal an toàn (giá nhập/giá bán), tránh NumberFormatException. */
    private BigDecimal parseMoney(String raw, String tenTruong, StringBuilder loi) {
        if (raw == null || raw.trim().isEmpty()) {
            loi.append("Chưa nhập " + tenTruong + ". ");
            return null;
        }
        try {
            BigDecimal value = new BigDecimal(raw.trim());
            if (value.compareTo(BigDecimal.ZERO) < 0) {
                loi.append(tenTruong + " không được âm. ");
                return null;
            }
            return value;
        } catch (NumberFormatException e) {
            loi.append(tenTruong + " không hợp lệ. ");
            return null;
        }
    }
}
