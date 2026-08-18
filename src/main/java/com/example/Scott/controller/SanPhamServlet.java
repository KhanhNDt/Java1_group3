package com.example.Scott.controller;

import com.example.Scott.entity.AnhMauSac;
import com.example.Scott.entity.ChiTietSanPham;
import com.example.Scott.entity.SanPham;
import com.example.Scott.responsitory.AnhMauSacResponsitory;
import com.example.Scott.responsitory.ChiTietSanPhamResponsitory;
import com.example.Scott.responsitory.SanPhamResponsitory;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
import java.util.Set;
import java.util.Locale;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
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
        "/san-pham/chi-tiet/ma-tran",
        "/san-pham/chi-tiet/add",
        "/san-pham/chi-tiet/update",
        "/san-pham/chi-tiet/view-update"
})
public class SanPhamServlet extends HttpServlet {

    private SanPhamResponsitory sanPhamResponsitory = new SanPhamResponsitory();
    private ChiTietSanPhamResponsitory chiTietSanPhamResponsitory = new ChiTietSanPhamResponsitory();
    private AnhMauSacResponsitory anhMauSacResponsitory = new AnhMauSacResponsitory();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("them-moi")) {
            this.hienThiThemMoi(request, response);
        } else if (uri.contains("goi-y")) {
            this.goiYSanPham(request, response);
        } else if (uri.contains("chi-tiet/ma-tran")) {
            this.layMaTranBienThe(request, response);
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
        loadThuocTinhChoThem(request);
        // Mã sản phẩm mới được sinh sẵn để hiển thị (chỉ đọc) trên form; mã thật sự lưu vào
        // DB vẫn được sinh lại (đảm bảo mới nhất) ngay trước khi ghi ở addSanPham().
        request.setAttribute("goiYMaSanPham", sanPhamResponsitory.generateNextMaSanPham());
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
        StringBuilder loi = validateSanPhamRequest(request, null, true);

        String[] mauValues = request.getParameterValues("variantMauSac");
        String[] sizeValues = request.getParameterValues("variantSize");
        String[] giaNhapValues = request.getParameterValues("variantGiaNhap");
        String[] giaBanValues = request.getParameterValues("variantGiaBan");
        String[] soLuongValues = request.getParameterValues("variantSoLuongTon");
        // variantMa là TÙY CHỌN: nếu người dùng để trống ô "Mã biến thể" thì hệ thống
        // vẫn tự sinh mã như cũ; nếu điền thì dùng đúng mã đó (sau khi kiểm tra trùng).
        String[] maValues = request.getParameterValues("variantMa");

        int rowCount = mauValues == null ? 0 : mauValues.length;
        if (rowCount == 0) {
            loi.append("Sản phẩm bắt buộc phải có ít nhất một biến thể. ");
        } else if (rowCount > 100) {
            loi.append("Mỗi lần chỉ được tạo tối đa 100 biến thể. ");
        } else if (sizeValues == null || giaNhapValues == null || giaBanValues == null || soLuongValues == null
                || sizeValues.length != rowCount || giaNhapValues.length != rowCount
                || giaBanValues.length != rowCount || soLuongValues.length != rowCount
                || (maValues != null && maValues.length != rowCount)) {
            loi.append("Dữ liệu biến thể không đầy đủ hoặc số cột không khớp nhau. ");
        }

        // Không dựng entity khi thông tin sản phẩm/khung dữ liệu biến thể còn sai,
        // tránh NumberFormatException do select bắt buộc đang rỗng.
        if (loi.length() > 0) {
            renderProductFormError(request, response, "Không thể thêm sản phẩm. " + loi);
            return;
        }

        SanPham sp = buildSanPhamFromRequest(request, new SanPham(), true);
        saveProductImage(request, sp);
        sp.setMaSanPham(sanPhamResponsitory.generateNextMaSanPham());
        List<ChiTietSanPham> bienTheList = new ArrayList<>();
        Set<String> combinations = new HashSet<>();
        Set<String> codes = new HashSet<>();
        // Màu nào đã xuất hiện ở ít nhất 1 dòng hợp lệ -> dùng để tìm file ảnh riêng theo màu (anhMau_<idMau>).
        java.util.LinkedHashSet<Integer> distinctColorIds = new java.util.LinkedHashSet<>();

        if (rowCount > 0 && loi.length() == 0) {
            for (int i = 0; i < rowCount; i++) {
                Integer idMau = parseInt(mauValues[i], "Màu biến thể dòng " + (i + 1), loi);
                Integer idSize = parseInt(sizeValues[i], "Size biến thể dòng " + (i + 1), loi);
                BigDecimal giaNhap = parseMoney(giaNhapValues[i], "Giá nhập dòng " + (i + 1), loi);
                BigDecimal giaBan = parseMoney(giaBanValues[i], "Giá bán dòng " + (i + 1), loi);
                Integer soLuong = parseInt(soLuongValues[i], "Số lượng dòng " + (i + 1), loi);
                String maTuyChon = maValues == null ? null : (maValues[i] == null ? null : maValues[i].trim());

                com.example.Scott.entity.MauSac mau = idMau == null ? null : chiTietSanPhamResponsitory.getMauSac(idMau);
                com.example.Scott.entity.Size size = idSize == null ? null : chiTietSanPhamResponsitory.getSize(idSize);
                if (idMau != null && mau == null) loi.append("Màu ở dòng ").append(i + 1).append(" không tồn tại. ");
                if (idSize != null && size == null) loi.append("Size ở dòng ").append(i + 1).append(" không tồn tại. ");
                if (giaNhap != null && giaNhap.compareTo(BigDecimal.ZERO) < 0) loi.append("Giá nhập dòng ").append(i + 1).append(" không được âm. ");
                if (giaBan != null && giaBan.compareTo(BigDecimal.ZERO) < 0) loi.append("Giá bán dòng ").append(i + 1).append(" không được âm. ");
                if (giaNhap != null && giaBan != null && giaBan.compareTo(giaNhap) < 0) loi.append("Giá bán dòng ").append(i + 1).append(" phải lớn hơn hoặc bằng giá nhập. ");
                if (soLuong != null && soLuong < 0) loi.append("Số lượng dòng ").append(i + 1).append(" không được âm. ");
                if (maTuyChon != null && !maTuyChon.isEmpty() && maTuyChon.length() > 50) loi.append("Mã biến thể dòng ").append(i + 1).append(" tối đa 50 ký tự. ");

                if (mau != null && size != null && giaNhap != null && giaBan != null && soLuong != null) {
                    String combination = idMau + "-" + idSize;
                    if (!combinations.add(combination)) {
                        loi.append("Biến thể dòng ").append(i + 1).append(" bị trùng màu và size với dòng trước. ");
                        continue;
                    }

                    String ma;
                    if (maTuyChon != null && !maTuyChon.isEmpty()) {
                        // Người dùng tự nhập mã -> phải đúng mã đó, không tự ý đổi. Báo lỗi rõ ràng nếu trùng.
                        if (chiTietSanPhamResponsitory.existsMa(maTuyChon, null) || codes.contains(maTuyChon)) {
                            loi.append("Mã biến thể \"").append(maTuyChon).append("\" ở dòng ").append(i + 1).append(" đã tồn tại, vui lòng đổi mã khác. ");
                            continue;
                        }
                        ma = maTuyChon;
                    } else {
                        // Để trống -> tự sinh mã như cũ (SP-MÀU-SIZE, tự thêm hậu tố nếu trùng).
                        String maGoc = taoMaBienThe(sp, mau, size);
                        ma = maGoc;
                        int suffix = 2;
                        while (chiTietSanPhamResponsitory.existsMa(ma, null) || codes.contains(ma)) {
                            String duoi = "-" + suffix++;
                            ma = gioiHanMa(maGoc, Math.max(1, 50 - duoi.length())) + duoi;
                        }
                    }
                    codes.add(ma);
                    distinctColorIds.add(idMau);

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

            // Nếu ngay từ lúc tạo, tất cả biến thể đều nhập số lượng tồn = 0 thì tự động
            // chuyển sản phẩm sang "Ngừng bán" luôn (đồng bộ với hành vi khi sửa biến thể).
            sanPhamResponsitory.dongBoTrangThaiTheoTonKho(sp.getId());

            // Ảnh riêng theo từng màu (tùy chọn): mỗi nhóm màu trong form có 1 ô file tên
            // "anhMau_<idMauSac>". Lưu sau khi sản phẩm đã có id, không chặn việc thêm
            // sản phẩm nếu 1 ảnh nào đó lỗi (chỉ bỏ qua, không rollback toàn bộ).
            for (Integer idMau : distinctColorIds) {
                try {
                    String duongDan = saveImagePartIfPresent(request, "anhMau_" + idMau, "Ảnh màu");
                    if (duongDan != null) {
                        anhMauSacResponsitory.luuAnh(sp.getId(), idMau, duongDan);
                    }
                } catch (Exception ignored) {
                    // Không để lỗi ảnh 1 màu làm mất công thêm cả sản phẩm đã lưu thành công.
                }
            }

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
        saveProductImage(request, sp);
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
        return validateSanPhamRequest(request, excludeId, false);
    }

    private StringBuilder validateSanPhamRequest(HttpServletRequest request, Integer excludeId, boolean isAdd) {
        StringBuilder loi = new StringBuilder();
        String ten = normalize(request.getParameter("tenSanPham"));
        String moTa = normalize(request.getParameter("moTa"));

        if (ten.length() < 3 || ten.length() > 100) loi.append("Tên sản phẩm phải từ 3 đến 100 ký tự. ");
        else if (sanPhamResponsitory.existsTenSanPham(ten, excludeId)) loi.append("Tên sản phẩm \"").append(ten).append("\" đã tồn tại, vui lòng đặt tên khác. ");
        if (moTa.length() > 500) loi.append("Mô tả không được vượt quá 500 ký tự. ");

        String gioiTinh = request.getParameter("gioiTinh");
        if (!("0".equals(gioiTinh) || "1".equals(gioiTinh))) loi.append("Giới tính không hợp lệ. ");

        // Khi thêm mới sản phẩm luôn mặc định "Đang bán" -> không có ô chọn trạng thái trên form,
        // nên không kiểm tra tham số trangThai trong trường hợp này.
        if (!isAdd) {
            String trangThai = request.getParameter("trangThai");
            if (!("0".equals(trangThai) || "1".equals(trangThai))) loi.append("Trạng thái không hợp lệ. ");
        }

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
        return buildSanPhamFromRequest(request, sp, false);
    }

    private SanPham buildSanPhamFromRequest(HttpServletRequest request, SanPham sp, boolean isAdd) {
        // Khi cập nhật, giữ nguyên mã đã sinh; khi thêm mới mã được gán ngay trước khi lưu.
        sp.setTenSanPham(normalize(request.getParameter("tenSanPham")));
        sp.setMoTa(normalize(request.getParameter("moTa")));
        sp.setGioiTinh("1".equals(request.getParameter("gioiTinh")));
        // Thêm mới sản phẩm luôn mặc định "Đang bán" (1); trạng thái chỉ có thể đổi khi sửa/cập nhật.
        sp.setTrangThai(isAdd ? 1 : Integer.valueOf(request.getParameter("trangThai")));
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
        loadThuocTinhChoThem(request);
        request.setAttribute("goiYMaSanPham", sanPhamResponsitory.generateNextMaSanPham());
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
        if (CT != null) {
            AnhMauSac anhHienTai = anhMauSacResponsitory.getBySanPhamVaMau(CT.getSanPham().getId(), CT.getMauSac().getId());
            request.setAttribute("anhMauHienTai", anhHienTai == null ? null : anhHienTai.getDuongDanAnh());
        }
        moveFlash(request);
        request.getRequestDispatcher("/views/sanpham/edit-variant.jsp").forward(request, response);
    }

    // ================= MA TRẬN MÀU x SIZE (AJAX cho modal "Thêm biến thể mới") =================
    // Trả về JSON: danh sách màu, danh sách size (kèm trạng thái hoạt động) và danh sách
    // tổ hợp màu+size ĐÃ TỒN TẠI của 1 sản phẩm, để front-end tô xám/khóa các ô đã có,
    // tránh cho người dùng chọn trùng ngay từ khi tick chọn (thay vì chỉ báo lỗi sau khi bấm Lưu).
    private void layMaTranBienThe(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Integer idSanPham = parseIntOrNull(request.getParameter("idSanPham"));
        Map<String, Object> data = new LinkedHashMap<>();
        if (idSanPham == null || sanPhamResponsitory.getOne(idSanPham) == null) {
            data.put("success", false);
            data.put("message", "Sản phẩm không tồn tại.");
            response.getWriter().write(new Gson().toJson(data));
            return;
        }

        List<Map<String, Object>> mauSacJson = new ArrayList<>();
        for (com.example.Scott.entity.MauSac x : chiTietSanPhamResponsitory.getAllMauSac()) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", x.getId());
            m.put("ten", x.getTen());
            m.put("active", x.getTrangThai() != null && x.getTrangThai() == 1);
            mauSacJson.add(m);
        }
        List<Map<String, Object>> sizeJson = new ArrayList<>();
        for (com.example.Scott.entity.Size x : chiTietSanPhamResponsitory.getAllSize()) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", x.getId());
            m.put("ten", x.getTen());
            m.put("active", x.getTrangThai() != null && x.getTrangThai() == 1);
            sizeJson.add(m);
        }

        // Tổ hợp đã tồn tại: lấy TOÀN BỘ biến thể của sản phẩm (không phân trang) để
        // đảm bảo không bỏ sót — khớp đúng với điều kiện existsCombination() dùng khi lưu.
        List<String> existing = new ArrayList<>();
        for (ChiTietSanPham ct : chiTietSanPhamResponsitory.getBySanPham(idSanPham)) {
            existing.add(ct.getMauSac().getId() + "-" + ct.getSize().getId());
        }

        data.put("success", true);
        data.put("mauSac", mauSacJson);
        data.put("size", sizeJson);
        data.put("existing", existing);
        response.getWriter().write(new Gson().toJson(data));
    }

    private void addChiTietSanPham(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder loi = new StringBuilder();
        Integer idSanPham = parseInt(request.getParameter("idSanPham"), "Sản phẩm", loi);
        if (idSanPham == null || sanPhamResponsitory.getOne(idSanPham) == null) {
            request.getSession().setAttribute("error", "Thêm biến thể thất bại: Sản phẩm không tồn tại.");
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi");
            return;
        }

        // Mỗi ô được tick trong ma trận màu x size gửi lên dưới dạng "idMau-idSize"
        // (tham số "combo", có thể lặp lại nhiều lần) — đây là các TỔ HỢP CHÍNH XÁC
        // người dùng chọn, không còn suy ra bằng tích chéo (cross-join) giữa danh sách
        // màu và danh sách size như trước, nên không còn tình trạng vô tình chọn phải
        // tổ hợp đã tồn tại của 1 màu trong khi các màu khác vẫn còn size trống.
        String[] comboValues = request.getParameterValues("combo");
        if (comboValues == null || comboValues.length == 0) {
            loi.append("Phải chọn ít nhất một ô màu × size trong bảng. ");
        }

        Integer soLuongTon = parseInt(request.getParameter("soLuongTon"), "Tồn kho", loi);
        BigDecimal giaNhap = parseMoney(request.getParameter("giaNhap"), "Giá nhập", loi);
        BigDecimal giaBan = parseMoney(request.getParameter("giaBan"), "Giá bán", loi);

        if (soLuongTon != null && soLuongTon < 0) loi.append("Tồn kho không được âm. ");
        if (giaNhap != null && giaNhap.compareTo(BigDecimal.ZERO) < 0) loi.append("Giá nhập không được âm. ");
        if (giaBan != null && giaBan.compareTo(BigDecimal.ZERO) < 0) loi.append("Giá bán không được âm. ");
        if (giaNhap != null && giaBan != null && giaBan.compareTo(giaNhap) < 0) {
            loi.append("Giá bán không được nhỏ hơn giá nhập. ");
        }

        if (loi.length() > 0) {
            request.getSession().setAttribute("error", "Thêm biến thể thất bại: " + loi);
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + idSanPham);
            return;
        }

        // Phân tích + kiểm tra từng ô đã chọn. Nếu có BẤT KỲ ô nào không hợp lệ hoặc đã
        // tồn tại, dừng lại và báo lỗi rõ ràng — KHÔNG lưu và cũng KHÔNG âm thầm bỏ qua
        // như trước đây, để người dùng biết chính xác mình đang chọn trùng ô nào.
        SanPham sanPham = sanPhamResponsitory.getOne(idSanPham);
        List<ChiTietSanPham> danhSachMoi = new ArrayList<>();
        Set<String> comboTrongLo = new HashSet<>();
        Set<String> maTrongLo = new HashSet<>();

        for (String combo : comboValues) {
            String[] parts = combo == null ? null : combo.split("-");
            Integer idMau = null, idSize = null;
            if (parts != null && parts.length == 2) {
                idMau = parseIntOrNull(parts[0]);
                idSize = parseIntOrNull(parts[1]);
            }
            if (idMau == null || idSize == null) {
                loi.append("Dữ liệu ô biến thể không hợp lệ. ");
                continue;
            }

            com.example.Scott.entity.MauSac mau = chiTietSanPhamResponsitory.getMauSac(idMau);
            com.example.Scott.entity.Size size = chiTietSanPhamResponsitory.getSize(idSize);
            if (mau == null || size == null) {
                loi.append("Màu sắc hoặc size không tồn tại. ");
                continue;
            }

            String key = idMau + "-" + idSize;
            if (!comboTrongLo.add(key)) continue; // bỏ qua nếu người dùng lỡ gửi trùng cùng 1 ô 2 lần trong 1 lượt chọn

            if (chiTietSanPhamResponsitory.existsCombination(idSanPham, idMau, idSize, null)) {
                loi.append("Biến thể ").append(mau.getTen()).append(" - ").append(size.getTen()).append(" đã tồn tại. ");
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

        if (loi.length() > 0) {
            request.getSession().setAttribute("error", "Thêm biến thể thất bại: " + loi);
        } else if (danhSachMoi.isEmpty()) {
            request.getSession().setAttribute("error", "Không có biến thể mới nào được chọn.");
        } else {
            try {
                chiTietSanPhamResponsitory.addMany(danhSachMoi);
                sanPhamResponsitory.dongBoTrangThaiTheoTonKho(idSanPham);
                request.getSession().setAttribute("success", "Đã thêm " + danhSachMoi.size() + " biến thể thành công.");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Thêm biến thể thất bại. Toàn bộ lô đã được hoàn tác: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi?selectedId=" + idSanPham);
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

            // Nếu vừa sửa số lượng tồn xuống 0 (hoặc tổng tồn các biến thể còn lại của
            // sản phẩm này bằng 0), tự động chuyển sản phẩm sang "Ngừng bán" để không còn
            // hiển thị/bán được ở màn hình Bán hàng tại quầy.
            sanPhamResponsitory.dongBoTrangThaiTheoTonKho(idSanPham);

            // Ảnh riêng theo màu (tùy chọn): để trống ô file thì giữ nguyên ảnh màu hiện có.
            try {
                String duongDan = saveImagePartIfPresent(request, "anhMauFile", "Ảnh màu");
                if (duongDan != null) {
                    anhMauSacResponsitory.luuAnh(idSanPham, idMauSac, duongDan);
                }
            } catch (Exception ignored) {
                // Không để lỗi ảnh làm mất công cập nhật biến thể đã lưu thành công.
            }

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

        List<ChiTietSanPham> trangHienTai = chiTietSanPhamResponsitory.getPage(
                keyword, idSanPham, idMauSac, idSize, tonKho, soLuong, trangThai, giaToiDa, page, pageSize);
        request.setAttribute("listAllChiTiet", trangHienTai);

        // Map "idSanPham_idMauSac" -> đường dẫn ảnh riêng theo màu, chỉ tính cho các dòng
        // đang hiển thị trên trang này. Nếu 1 màu chưa có ảnh riêng, JSP sẽ tự fallback
        // về ảnh bìa của sản phẩm (sanPham.hinhAnh).
        Map<String, String> anhTheoMauMap = new LinkedHashMap<>();
        for (ChiTietSanPham ct : trangHienTai) {
            String key = ct.getSanPham().getId() + "_" + ct.getMauSac().getId();
            if (anhTheoMauMap.containsKey(key)) continue;
            AnhMauSac anh = anhMauSacResponsitory.getBySanPhamVaMau(ct.getSanPham().getId(), ct.getMauSac().getId());
            if (anh != null) anhTheoMauMap.put(key, anh.getDuongDanAnh());
        }
        request.setAttribute("anhTheoMauMap", anhTheoMauMap);

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

    /**
     * Chỉ dùng cho FORM THÊM SẢN PHẨM: loại bỏ những thuộc tính đã bị "Ngừng hoạt động"
     * (trangThai != 1) khỏi danh sách để chọn, theo yêu cầu quản lý thuộc tính.
     * Không dùng cho form sửa / bộ lọc danh sách vì sản phẩm cũ có thể đang gắn
     * thuộc tính đã ngừng và vẫn cần hiển thị đúng giá trị hiện tại của nó.
     */
    private void loadThuocTinhChoThem(HttpServletRequest request) {
        request.setAttribute("listThuongHieu", sanPhamResponsitory.getThuongHieuDangHoatDong());
        request.setAttribute("listDanhMuc", sanPhamResponsitory.getDanhMucDangHoatDong());
        request.setAttribute("listChatLieu", sanPhamResponsitory.getChatLieuDangHoatDong());
        request.setAttribute("listKieuDang", sanPhamResponsitory.getKieuDangDangHoatDong());
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

    private String normalizeMoney(String raw) {
        String value = raw == null ? "" : raw.trim().replace(" ", "");
        if (value.matches("^\\d{1,3}([.,]\\d{3})+$")) {
            return value.replace(".", "").replace(",", "");
        }
        return value.replace(",", ".");
    }

    private void saveProductImage(HttpServletRequest request, SanPham sp) throws IOException, ServletException {
        String duongDan = saveImagePartIfPresent(request, "hinhAnhFile", "Ảnh sản phẩm");
        if (duongDan != null) sp.setHinhAnh(duongDan);
    }

    /**
     * Lưu file ảnh từ 1 Part multipart lên đĩa (nếu có) và trả về đường dẫn tương đối
     * (VD "uploads/products/xxx.jpg") để lưu vào cột hinh_anh/duong_dan_anh trong DB.
     * Trả về null nếu người dùng không chọn file nào (part rỗng) — nghĩa là giữ nguyên ảnh cũ.
     * Dùng chung cho cả ảnh cấp sản phẩm và ảnh theo màu, tránh lặp code.
     */
    private String saveImagePartIfPresent(HttpServletRequest request, String tenPart, String nhan) throws IOException, ServletException {
        Part part;
        try {
            part = request.getPart(tenPart);
        } catch (IOException | ServletException e) {
            return null; // không phải request multipart hoặc không có part này
        }
        if (part == null || part.getSize() == 0) return null;
        String contentType = part.getContentType();
        if (contentType == null || !(contentType.equals("image/jpeg") || contentType.equals("image/png") || contentType.equals("image/webp"))) {
            throw new ServletException(nhan + " chỉ chấp nhận JPG, PNG hoặc WEBP.");
        }
        String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String ext = submitted.contains(".") ? submitted.substring(submitted.lastIndexOf('.')).toLowerCase(Locale.ROOT) : ".jpg";
        String fileName = UUID.randomUUID().toString().replace("-", "") + ext;
        String relativeDir = "uploads/products";
        String realDir = request.getServletContext().getRealPath("/" + relativeDir);
        if (realDir == null) throw new ServletException("Không xác định được thư mục lưu ảnh trên máy chủ.");
        Path dir = Paths.get(realDir);
        Files.createDirectories(dir);
        try (java.io.InputStream input = part.getInputStream()) {
            Files.copy(input, dir.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
        }
        return relativeDir + "/" + fileName;
    }

    private BigDecimal parseMoneyOrNull(String raw) {
        if (raw == null || raw.trim().isEmpty()) return null;
        try {
            BigDecimal value = new BigDecimal(normalizeMoney(raw));
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
            String normalized = normalizeMoney(raw);
            BigDecimal value = new BigDecimal(normalized);
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
