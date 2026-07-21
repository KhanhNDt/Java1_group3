-- SQL Server: dùng NVARCHAR để lưu chính xác giá trị "Nữ".
IF COL_LENGTH('dbo.khach_hang', 'gioi_tinh') IS NULL
BEGIN
    ALTER TABLE dbo.khach_hang ADD gioi_tinh NVARCHAR(20) NULL;
END
ELSE
BEGIN
    ALTER TABLE dbo.khach_hang ALTER COLUMN gioi_tinh NVARCHAR(20) NULL;
END;
GO

-- Chuẩn hóa các dữ liệu cũ nếu trước đây lưu Boolean/0/1/không dấu.
UPDATE dbo.khach_hang
SET gioi_tinh = CASE
    WHEN LOWER(LTRIM(RTRIM(gioi_tinh))) IN (N'nam', N'1', N'true') THEN N'Nam'
    WHEN LOWER(LTRIM(RTRIM(gioi_tinh))) IN (N'nữ', N'nu', N'0', N'false') THEN N'Nữ'
    ELSE NULLIF(LTRIM(RTRIM(gioi_tinh)), N'')
END;
GO

-- district_code đang NOT NULL trong schema, module không dùng huyện nên dùng 0.
UPDATE dbo.dia_chi_api_mapping
SET district_code = 0
WHERE district_code IS NULL;
GO
