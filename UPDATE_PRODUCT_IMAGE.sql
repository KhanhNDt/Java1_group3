-- Chạy một lần trên SQL Server trước khi dùng chức năng tải ảnh.
IF COL_LENGTH('dbo.san_pham', 'hinh_anh') IS NULL
BEGIN
    ALTER TABLE dbo.san_pham ADD hinh_anh NVARCHAR(500) NULL;
END;
