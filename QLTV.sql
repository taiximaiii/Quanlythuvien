DROP DATABASE IF EXISTS `QLTV`;
create database `QLTV`;
use `QLTV`;

create table `TheLoai`(
	MaTheLoai nvarchar(50) primary key,
    TenTheLoai nvarchar(100) not null unique,
    GhiChu nvarchar(200)
);
create table`NhaXuatBan`(
	MaNXB nvarchar(50) primary key,
    TenNXB nvarchar(50) unique not null,
    DiaChi nvarchar(200)
    
);
create table `TacGia`(
	MaTacGia nvarchar(50) primary key,
    TenTacGia nvarchar(50) unique not null,
    GhiChu nvarchar(200)
);
create table `Sach`(
	MaSach nvarchar(50) primary key,
    TenSach nvarchar(100) not null,
    MaNXB nvarchar(50),
    MaTacGia nvarchar(50),
    NgayNhap date,
    ViTri nvarchar(50),
    Gia float not null,
    MaTheLoai nvarchar(50),
    SoLuongCo int unsigned not null,
    SoLuongCon int unsigned not null,
	foreign key(MaTheLoai) references `TheLoai`(MaTheLoai),
    foreign key(MaNXB) references `NhaXuatBan`(MaNXB),
    foreign key(MaTacGia) references `TacGia`(MaTacGia)
);
create table `VaiTro`(
	MaVaiTro nvarchar(50) primary key,
    TenVaiTro nvarchar(255)
);
create table `Khoa`(
	MaKhoa nvarchar(50) primary key,
    TenKhoa nvarchar(100)
);
create table `Lop`(
	MaLop nvarchar(50) primary key,
    TenLop nvarchar(100),
    MaKhoa nvarchar(50),
    foreign key(Makhoa) references `Khoa`(MaKhoa)
);
create table `NguoiDung`(
	MaNguoiDung nvarchar(50) primary key,
    TenNguoiDung nvarchar(50) not null,
    MatKhau varchar(50) not null,
    NgaySinh date,
    GioiTinh nvarchar(20),
    SDT char(15) not null,
    Email nvarchar(50) not null unique,
    DiaChi nvarchar(255) not null,
    TongTienPhat float default 0,
    MaVaiTro nvarchar(50),
    NGAYDANGKY date,
    NGAYHETHAN date,
    MaLop nvarchar(50),
    foreign key(MaVaiTro) references `VaiTro`(MaVaiTro),
    foreign key(MaLop) references `Lop` (MaLop)
);

create table `PhieuMuon`(
	MaNguoiDung nvarchar(50),
    MaSach nvarchar(50),
    NgayMuon date not null,
    HanTra date not null,
    primary key(MaNguoiDung,MaSach),
    foreign key(MaNguoiDung) references NguoiDung(MaNguoiDung),
    foreign key(MaSach) references Sach(MaSach)
);
create table `PhieuTra`(
	MaNguoiDung nvarchar(50),
    MaSach nvarchar(50),
    NgayTra date not null,
    primary key(MaNguoiDung,MaSach),
    foreign key(MaNguoiDung) references NguoiDung(MaNguoiDung),
    foreign key(MaSach) references Sach(MaSach)
);
create table `XuLyViPham`(
	MaNguoiDung nvarchar(50),
    TienPhat int,
	foreign key(MaNguoiDung) references NguoiDung(MaNguoiDung)
);
drop trigger if exists `tg_XuLyViPham` 
delimiter //
create trigger `tg_XuLyViPham` 
after insert on `PhieuTra`
for each row 
begin 
	if new.NgayTra > (select HanTra from `PhieuMuon` where MaNguoiDung = new.MaNguoiDung and MaSach = new.MaSach) then
		insert into `XuLyViPham`(MaNguoiDung,TienPhat)
        values (new.MaNguoiDung, 
        DATEDIFF(new.NgayTra, (select HanTra from `PhieuMuon` where MaNguoiDung = new.MaNguoiDung and MaSach = new.MaSach)) * 5000);
    end if;
end
// delimiter ;
-- trigger cập nhật số lượng sách khi mượn
drop trigger if exists `tg_MuonSach` 
delimiter //
create trigger `tg_MuonSach` 
after insert on `PhieuMuon`
for each row 
begin 
	update `Sach`
    set SoLuongCon = SoLuongCon -1 
    where MaSach = new.MaSach;
end
// delimiter ;

-- trigger cập nhật số lượng sách khi trả
drop trigger if exists `tg_TraSach` 
delimiter //
create trigger `tg_TraSach` 
after insert on `PhieuTra`
for each row 
begin 
	update `Sach`
    set SoLuongCon = SoLuongCon -1 
    where MaSach = new.MaSach;
end
// delimiter ;

drop trigger if exists `tg_XoaPhieuMuon` 
delimiter //
create trigger `tg_XoaPhieuMuon` 
after insert on `PhieuTra`
for each row 
begin 
	delete from `PhieuMuon`
    where MaNguoiDung = new.MaNguoiDung and MaSach = new.MaSach;
end
// delimiter ;

-- trigger cập nhập tiền phạt
drop trigger if exists `tg_themphat`
delimiter //
create trigger `tg_themphat`
after insert on `XuLyViPham`
for each row 
begin 
	update `NguoiDung`
    set TongTienPhat = TongTienPhat + new.TienPhat
    where MaNguoiDung = new.MaNguoiDung;
end
// delimiter ;


insert into TacGia(MaTacGia,TenTacGia,GhiChu) values (N'TG01', N'Vũ Trọng Phụng', NULL),
(N'TG02', N'Vu Triết', NULL),
(N'TG03', N'Dịch Nhân Bắc', NULL),
(N'TG04', N'BBC Worldwide Ltd', NULL),
(N'TG05', N'Steven Levy', NULL),
(N'TG06', N'JJ Ramberg', NULL),
(N'TG07', N'Eric Verzuh', NULL),
(N'TG08', N'Carlo Zen', NULL),
(N'TG09', N'Stephen Hawking', NULL),
(N'TG10', N'Victor Hugo', NULL),
(N'TG11', N'Kim Hye-jin', NULL),
(N'TG12', N'Astrid Lindgren', NULL),
(N'TG13', N'Tsujimura Mizuki', NULL),
(N'TG14', N'Thomas Billhardt', NULL),
(N'TG15', N'KTS. Nguyễn Ngọc Dũng', NULL),
(N'TG16', N'Catherine Ryan Hyde', NULL),
(N'TG17', N'Indrytimes', NULL);

insert into TheLoai(MaTheLoai,TenTheLoai,GhiChu) values (N'TL01', N'Anime', NULL),
(N'TL02', N'Light novel', NULL),
(N'TL03', N'BL', NULL),
(N'TL04', N'Khoa Học Kĩ Thuật', NULL),
(N'TL05', N'Kinh Tế', NULL),
(N'TL06', N'Lịch sử', NULL),
(N'TL07', N'Văn học - Tiểu thuyết', NULL),
(N'TL08', N'Văn hóa - Du lịch', NULL);

insert into NhaXuatBan(MaNXB,TenNXB,DiaChi) values (N'NXB1', N'Kim Đồng', N'55 Quang Trung, Hà Nội, Việt Nam'),
(N'NXB10', N'Lao Động', N'175 P. Giảng Võ, Chợ Dừa, Đống Đa, Hà Nội'),
(N'NXB11', N'Thông Tấn', N'79 Lý Thường Kiệt, Phan Chu Trinh, Hoàn Kiếm, Hà Nội'),
(N'NXB12', N'Văn Học', N'20 Nam Kỳ Khởi Nghĩa, Phường 8, Quận 3, Thành phố Hồ Chí Minh'),
(N'NXB13', N'Thế Giới', N'7 Nguyễn Thị Minh Khai, Bến Nghé, Quận 1, Thành phố Hồ Chí Minh'),
(N'NXB2', N'Trẻ', N' 161B Lý Chính Thắng; Phường 7; Quận 3; Thành phố Hồ Chí Minh'),
(N'NXB3', N'Thanh Xuân', N'Tầng 6, Tòa nhà Cục Tần số vô tuyến điện, 115, Trần Duy Hưng, Thanh Xuân Trung, Thanh Xuân, Hà Nội'),
(N'NXB4', N'Hà Nội', N'số 4 Tống Duy Tân, Hàng Bông, Hoàn Kiếm, Hà Nội'),
(N'NXB5', N'Dân Trí', N'Số 9, ngõ 26, phố Hoàng Cầu, phường Ô Chợ Dừa, quận Đống Đa, Hà Nội'),
(N'NXB6', N'Tri Thức', N'Tầng 1, Tòa nhà VUSTA, 53, Nguyễn Du, Hai Bà Trưng, Hà Nội'),
(N'NXB7', N'Công Thương', N'46 P. Ngô Quyền, Hàng Bài, Hoàn Kiếm, Hà Nội'),
(N'NXB8', N'Kinh Tế TP.HCM', N'279 Nguyễn Tri Phương – Phường 5 – Quận 10 – TP. Hồ Chí Minh'),
(N'NXB9', N'Thanh Hóa', N'248 Trần Phú, P. Ba Đình, Thành phố Thanh Hóa, Thanh Hoá');

insert into Sach(MaSach,TenSach,Gia,MaTacGia,MaNXB,MaTheLoai,SoLuongCo,SoLuongCon,NgayNhap,ViTri) values (N'S1', N'Mononoke Princess', 50000, N'TG01', N'NXB1', N'TL01', 25, 24,'2023-05-27','Kệ 7'),
(N'S10', N'Thánh kinh trong người mới khởi nghiệp', 96000, N'TG07', N'NXB9', N'TL05', 10, 10,'2022-06-23','Kệ 5'),
(N'S11', N'AI trong Marketing', 189000, N'TG08', N'NXB10', N'TL05', 10, 10,'2023-05-22','Kệ 1'),
(N'S12', N'Con rồng cháu tiên', 135000, N'TG04', N'NXB2', N'TL06', 10, 10,'2023-05-22','Kệ 7'),
(N'S13', N'Tanya chiến ký', 209000, N'TG09', N'NXB4', N'TL02', 10, 10,'2023-05-21','Kệ 10'),
(N'S14', N'Lược sử thời gian', 95000, N'TG10', N'NXB2', N'TL04', 10, 10,'2023-05-22','Kệ 1'),
(N'S15', N'Ngày cuối cùng của một tử tù', 75000, N'TG11', N'NXB13', N'TL07', 10, 10,'2023-05-27','Kệ 6'),
(N'S16', N'Về nhà với mẹ', 89000, N'TG12', N'NXB5', N'TL07', 10, 10,'2023-05-27','Kệ 4'),
(N'S17', N'Pippi tất dài', 94000, N'TG13', N'NXB12', N'TL07', 10, 10,'2023-05-27','Kệ 2'),
(N'S18', N'Những người khốn khổ', 395000, N'TG11', N'NXB12', N'TL07', 10, 10,'2023-05-27','Kệ 10'),
(N'S19', N'Cô thành trong gương', 218000, N'TG14', N'NXB4', N'TL07', 10, 10,'2023-05-27','Kệ 1'),
(N'S2', N'Castle in the sky', 200000, N'TG03', N'NXB1', N'TL02', 39, 39,'2023-05-27','Kệ 2'),
(N'S20', N'Hà Nội 1967 - 1975', 28000, N'TG15', N'NXB13', N'TL06', 10, 10,'2023-05-27','Kệ 3'),
(N'S21', N'Mình về nhà thôi', 110000, N'TG17', N'NXB10', N'TL07', 10, 10,'2023-05-27','Kệ 5'),
(N'S22', N'Sài Gòn trăm bước', 268000, N'TG16', N'NXB11', N'TL08', 10, 10,'2023-05-27','Kệ 8'),
(N'S3', N'Spirited away', 50000, N'TG02', N'NXB3', N'TL03', 20, 19,'2023-05-27','Kệ 9'),
(N'S4', N'My Neighbor Totoro', 50000, N'TG02', N'NXB4', N'TL01', 10, 10,'2023-05-27','Kệ 9'),
(N'S5', N'Ponyo', 100000, N'TG02', N'NXB1', N'TL01', 25, 25,'2023-05-27','Kệ 8'),
(N'S6', N'Trí tuệ nhân tạo', 69000, N'TG04', N'NXB5', N'TL04', 10, 10,'2023-05-27','Kệ 2'),
(N'S7', N'Stephen Hawking: Một trí tuệ không giới hạn', 189000, N'TG05', N'NXB6', N'TL04', 10, 9,'2023-05-27','Kệ 2'),
(N'S8', N'Hacker lược sử', 299000, N'TG06', N'NXB7', N'TL04', 10, 10,'2023-05-27','Kệ 1'),
(N'S9', N'Hiệu ứng chim mồi', 75000, N'TG04', N'NXB8', N'TL05', 1, 1,'2023-05-27','Kệ 2');

insert into VaiTro(MaVaiTro,TenVaiTro) values ('VT01','Độc giả'),('VT02','Admin');
insert into `Khoa` (MaKhoa,TenKhoa) values (N'KHMT', N'Khoa học máy tính'),
(N'CNTT', N'Công nghệ thông tin'),
(N'XDDD', N'Xây dựng dân dụng'),
(N'CD', N'Câu đường'),
(N'LOG', N'Logictics');

insert into `Lop`(MaLop,TenLop,MaKhoa) values (N'CD2', N'Cầu đường 2', N'CD'),
(N'CS1', N'Khoa học máy tính 1', N'KHMT'),
(N'CS2', N'Khoa học máy tính 2', N'KHMT'),
(N'IT1', N'Công nghệ thông tin 1', N'CNTT'),
(N'IT2', N'Công nghệ thông tin 2', N'CNTT'),
(N'IT3', N'Công nghệ thông tin 3', N'CNTT'),
(N'CD1', N'Cầu đường 1', N'CD'),
(N'XDDD1', N'Xây dựng dân dụng', N'XDDD');

insert into NguoiDung (MaNguoiDung,TenNguoiDung, MatKhau , SDT, Email, NgaySinh, GioiTinh, DiaChi,MaVaiTro,NgayDangKy,NgayHetHan,MaLop) values ('D01','Jeanette Eilhart', 'D01', '3192453871', 'jeilhart0@oakley.com', '1998-01-02', 'Nữ', '01 Clove Crossing','VT01','2023-05-03','2023-12-12','CS1'),
('D02','Hannis Tingley', 'UZSvsc3l4eM', '1219171051', 'htingley1@intel.com', '2003-07-25', 'Nữ', '4 Lawn Hill','VT01','2023-05-03','2023-12-12','CS1'),
('D03','Cissy Lewendon', 'IrFX3DDfktmg', '2306031057', 'clewendon2@theglobeandmail.com', '1996-09-07', 'Nữ', '8186 Ryan Lane','VT01','2023-05-03','2023-12-12','CS2'),
('D04','Vivien Grombridge', '6UOZdU', '6869488366', 'vgrombridge3@stanford.edu', '1995-07-29', 'Nữ', '24782 Raven Parkway','VT01','2023-05-03','2023-12-12','CS1'),
('D05','Berkly Shyram', '1X3s8u9', '5349316342', 'bshyram4@redcross.org', '1999-02-02', 'Nam', '0 Old Gate Street','VT01','2023-05-03','2023-12-12','IT2'),
('D06','Thomasin Balcock', 'smv9ZtTAo', '7662772957', 'tbalcock5@msn.com', '1999-08-21', 'Nữ', '44 Mallard Terrace','VT01','2023-05-03','2023-12-12','IT3'),
('D07','Franciska Mogie', 'YnGGzY', '1631072715', 'fmogie6@linkedin.com', '1995-01-25', 'Nữ', '13488 Meadow Ridge Pass','VT01','2023-05-03','2023-12-12','CD1'),
('D08','Ogdon Firebrace', 'hgQ984bOs4b', '6697107988', 'ofirebrace7@mlb.com', '1994-03-24', 'Nam', '6 Kennedy Point','VT01','2023-05-03','2023-12-12','XDDD1'),
('D09','Abdul Scranedge', 'fgBtIe1P', '3655482968', 'ascranedge8@state.tx.us', '2000-05-17', 'Nam', '4 Tennyson Lane','VT01','2023-05-03','2023-12-12','IT1'),
('D10','Sigfried Tollfree', 'ERtt3bIM', '4142798337', 'stollfree9@feedburner.com', '2000-10-19', 'Nam', '22 Esker Court','VT01','2023-05-03','2023-12-12','CS1'),
('D11','Ashlen Ferneley', 'T7kSUIdMREDi', '8694928772', 'aferneleya@fda.gov', '1996-01-07', 'Nữ', '8320 Lerdahl Drive','VT01','2023-05-03','2023-12-12','CS2'),
('D12','Leola Sainz', '7HkzrJ0', '1909737805', 'lsainzb@a8.net', '1992-01-20', 'Nữ', '43 Stuart Hill','VT01','2023-05-03','2023-12-12','IT3'),
('D13','Marietta Broggio', 'bmjrmQDF64', '8589061899', 'mbroggioc@blogger.com', '1995-02-14', 'Nam', '6365 South Court','VT01','2023-05-03','2023-12-12','CD1'),
('D14','Phylys Prandi', 'jvLHrpt6E', '5795334514', 'pprandi1d@uol.com.br', '1993-06-12', 'Nữ', '5 Hanover Circle','VT01','2023-05-03','2023-12-12','CD1'),
('admin',N'Trần Công Tài', 'admin1', '5795334514', 'tai@123.com', '2002-08-06', 'Nam', '5 Hanover Circle','VT02','2023-05-01','2025-12-12','CS1');

insert into PhieuMuon(MaNguoiDung,MaSach,NgayMuon,HanTra) values (N'D03', N'S1', '2023-06-03', '2023-06-10'),
(N'D01', N'S3', '2023-05-03' , '2023-05-16' ),
(N'D06', N'S7', '2023-05-23' ,'2023-06-03'),
(N'D13', N'S8', '2023-05-24' ,'2023-06-11' ),
(N'D14', N'S3', '2023-05-29' ,'2023-06-11' ),
(N'D06', N'S4', '2023-05-29' ,'2023-06-11' ),
(N'D03', N'S7', '2023-05-29' ,'2023-06-12' ),
(N'D06', N'S1', '2023-05-29' ,'2023-06-13' ),
(N'D03', N'S2', '2023-05-29' ,'2023-06-01' ),
(N'D07', N'S1', '2023-05-29' ,'2023-06-02' ),
(N'D10', N'S9', '2023-05-29' ,'2023-06-14' ),
(N'D11', N'S2', '2023-05-29' ,'2023-06-15' ),
(N'D13', N'S2', '2023-05-28' ,'2023-06-15' );
insert into PhieuTra(MaNguoiDung,MaSach,NgayTra) values
(N'D06', N'S8', '2023-06-04' ),
(N'D03', N'S2', '2023-06-05' );
select * from XuLyViPham;
select * from NguoiDung
