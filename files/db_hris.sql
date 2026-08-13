-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 20, 2026 at 05:22 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_hris`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `LihatInfoLengkap` (IN `kata_kunci` VARCHAR(100))   BEGIN
    
    SELECT 
        k.nip, k.nama_lengkap, d.nama_departemen, j.nama_jabatan, 
        l.nama_level, k.status_karyawan, k.tgl_masuk_kerja, k.foto_path
    FROM karyawan k
    JOIN departemen d ON k.kode_departemen = d.kode_departemen
    JOIN jabatan j ON k.id_jabatan = j.id_jabatan
    JOIN level_jabatan l ON k.id_level_jabatan = l.id_level
    WHERE k.nip = kata_kunci OR k.nama_lengkap LIKE CONCAT('%', kata_kunci, '%');

    
    SELECT '--- DATA ABSENSI ---' AS Kategori;
    SELECT tanggal, jam_masuk, jam_pulang, status_kehadiran, keterangan 
    FROM absensi 
    WHERE nip_karyawan = kata_kunci OR nip_karyawan IN (SELECT nip FROM karyawan WHERE nama_lengkap LIKE CONCAT('%', kata_kunci, '%'));

    
    SELECT '--- DATA CUTI ---' AS Kategori;
    SELECT tgl_mulai, tgl_selesai, jenis_cuti, status_persetujuan 
    FROM cuti 
    WHERE nip_karyawan = kata_kunci OR nip_karyawan IN (SELECT nip FROM karyawan WHERE nama_lengkap LIKE CONCAT('%', kata_kunci, '%'));

    
    SELECT '--- DATA LEMBUR ---' AS Kategori;
    SELECT tanggal, jam_mulai, jam_selesai, alasan, status_persetujuan 
    FROM lembur 
    WHERE nip_karyawan = kata_kunci OR nip_karyawan IN (SELECT nip FROM karyawan WHERE nama_lengkap LIKE CONCAT('%', kata_kunci, '%'));

    
    SELECT '--- PENILAIAN KINERJA ---' AS Kategori;
    SELECT periode_penilaian, nilai_akhir_skor, predikat_kinerja, catatan_manajer 
    FROM penilaian_kinerja 
    WHERE nip_karyawan = kata_kunci OR nip_karyawan IN (SELECT nip FROM karyawan WHERE nama_lengkap LIKE CONCAT('%', kata_kunci, '%'));

    
    SELECT '--- DATA GAJI ---' AS Kategori;
    SELECT periode_gaji, gaji_pokok, total_penambah, total_pengurang, total_gaji_diterima 
    FROM penggajian 
    WHERE nip_karyawan = kata_kunci OR nip_karyawan IN (SELECT nip FROM karyawan WHERE nama_lengkap LIKE CONCAT('%', kata_kunci, '%'));

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `absensi`
--

CREATE TABLE `absensi` (
  `id_absensi` int(11) NOT NULL,
  `nip_karyawan` varchar(20) DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `jam_masuk` time DEFAULT NULL,
  `jam_pulang` time DEFAULT NULL,
  `status_kehadiran` enum('Hadir','Izin','Sakit','Alpha','Cuti') DEFAULT NULL,
  `lokasi_kerja` enum('Kantor','Remote','Lapangan') DEFAULT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `absensi`
--

INSERT INTO `absensi` (`id_absensi`, `nip_karyawan`, `tanggal`, `jam_masuk`, `jam_pulang`, `status_kehadiran`, `lokasi_kerja`, `keterangan`) VALUES
(1, '2023002', '2025-07-01', '08:00:00', '17:00:00', 'Hadir', 'Kantor', 'On Time'),
(2, '2023002', '2025-07-02', '08:15:00', '17:15:00', 'Hadir', 'Kantor', 'Telat 15 menit'),
(3, '2023002', '2025-07-01', '08:00:00', '17:00:00', 'Hadir', 'Kantor', 'On Time'),
(4, '2023002', '2025-07-02', '08:15:00', '17:15:00', 'Hadir', 'Kantor', 'Telat 15 menit'),
(5, '2023001', '2025-07-01', '07:45:00', '16:30:00', 'Hadir', 'Kantor', 'Datang Pagi'),
(6, '2023001', '2025-07-02', '08:00:00', '18:00:00', 'Hadir', 'Kantor', 'Meeting seharian'),
(7, '2023003', '2025-07-01', '07:55:00', '17:05:00', 'Hadir', 'Kantor', 'On Time'),
(8, '2023004', '2025-07-01', '08:00:00', '17:00:00', 'Hadir', 'Kantor', 'On Time'),
(9, '2023005', '2025-07-01', '09:00:00', '18:00:00', 'Hadir', 'Remote', 'WFH');

-- --------------------------------------------------------

--
-- Table structure for table `cuti`
--

CREATE TABLE `cuti` (
  `id_cuti` int(11) NOT NULL,
  `nip_karyawan` varchar(20) DEFAULT NULL,
  `tgl_mulai` date DEFAULT NULL,
  `tgl_selesai` date DEFAULT NULL,
  `jenis_cuti` varchar(50) DEFAULT NULL,
  `alasan` text DEFAULT NULL,
  `status_persetujuan` enum('Menunggu','Disetujui','Ditolak') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cuti`
--

INSERT INTO `cuti` (`id_cuti`, `nip_karyawan`, `tgl_mulai`, `tgl_selesai`, `jenis_cuti`, `alasan`, `status_persetujuan`) VALUES
(1, '2023001', '2025-08-01', '2025-08-03', 'Tahunan', 'Liburan Keluarga', 'Disetujui'),
(2, '2023002', '2025-09-10', '2025-09-12', 'Sakit', 'Demam Tinggi', 'Disetujui'),
(3, '2023004', '2025-07-15', '2025-07-16', 'Sakit', 'Flu Berat', 'Disetujui');

-- --------------------------------------------------------

--
-- Table structure for table `departemen`
--

CREATE TABLE `departemen` (
  `kode_departemen` varchar(10) NOT NULL,
  `nama_departemen` varchar(100) NOT NULL,
  `nip_kepala` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departemen`
--

INSERT INTO `departemen` (`kode_departemen`, `nama_departemen`, `nip_kepala`) VALUES
('FIN01', 'Finance & Accounting', '2023001'),
('HR01', 'Human Resources', NULL),
('IT01', 'Teknologi Informasi', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jabatan`
--

CREATE TABLE `jabatan` (
  `id_jabatan` int(11) NOT NULL,
  `nama_jabatan` varchar(100) NOT NULL,
  `id_level_default` int(11) DEFAULT NULL,
  `deskripsi_jabatan` text DEFAULT NULL,
  `gaji_pokok_default` decimal(15,2) DEFAULT NULL,
  `tunjangan_jabatan` decimal(15,2) DEFAULT NULL,
  `tunjangan_keluarga` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jabatan`
--

INSERT INTO `jabatan` (`id_jabatan`, `nama_jabatan`, `id_level_default`, `deskripsi_jabatan`, `gaji_pokok_default`, `tunjangan_jabatan`, `tunjangan_keluarga`) VALUES
(1, 'Staff IT', 1, 'Programmer dan Support', 4000000.00, 500000.00, 500000.00),
(2, 'HR Supervisor', 2, 'Pengawas HR', 6000000.00, 1000000.00, 1000000.00),
(3, 'Finance Manager', 3, 'Manajer Keuangan', 10000000.00, 2000000.00, 1500000.00),
(4, 'Staff Finance', 1, 'Admin Keuangan', 4500000.00, 500000.00, 500000.00),
(5, 'Staff HR', 1, 'Admin HRD', 4200000.00, 500000.00, 500000.00);

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `nip` varchar(20) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `no_identitas` varchar(20) DEFAULT NULL,
  `jenis_kelamin` enum('L','P') DEFAULT NULL,
  `tempat_lahir` varchar(50) DEFAULT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `no_hp` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `status_pernikahan` enum('Kawin','Tidak Kawin') DEFAULT NULL,
  `jumlah_tanggungan` int(11) DEFAULT NULL,
  `pendidikan_terakhir` varchar(10) DEFAULT NULL,
  `tgl_masuk_kerja` date DEFAULT NULL,
  `status_karyawan` enum('Tetap','Kontrak','Magang') DEFAULT NULL,
  `id_jabatan` int(11) DEFAULT NULL,
  `id_level_jabatan` int(11) DEFAULT NULL,
  `kode_departemen` varchar(10) DEFAULT NULL,
  `status_ptkp` varchar(5) DEFAULT NULL,
  `npwp` varchar(25) DEFAULT NULL,
  `no_bpjs_kesehatan` varchar(20) DEFAULT NULL,
  `no_bpjs_ketenagakerjaan` varchar(20) DEFAULT NULL,
  `foto_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`nip`, `nama_lengkap`, `no_identitas`, `jenis_kelamin`, `tempat_lahir`, `tgl_lahir`, `no_hp`, `email`, `alamat`, `status_pernikahan`, `jumlah_tanggungan`, `pendidikan_terakhir`, `tgl_masuk_kerja`, `status_karyawan`, `id_jabatan`, `id_level_jabatan`, `kode_departemen`, `status_ptkp`, `npwp`, `no_bpjs_kesehatan`, `no_bpjs_ketenagakerjaan`, `foto_path`) VALUES
('2023001', 'Budi Santoso', '320100000000001', 'L', 'Jakarta', '1990-05-15', '08123456789', 'budi@kantor.com', 'Jl. Sudirman No. 1', 'Kawin', 2, 'S1', '2020-01-10', 'Tetap', 3, 3, 'FIN01', 'K/2', '12.345.678.9', '000111222', '111222333', 'foto_budi.jpg'),
('2023002', 'Siti Aminah', '320100000000002', 'P', 'Bandung', '1995-08-20', '08198765432', 'siti@kantor.com', 'Jl. Asia Afrika No. 5', 'Tidak Kawin', 0, 'S1', '2021-03-01', 'Tetap', 1, 1, 'IT01', 'TK/0', '98.765.432.1', '000333444', '333444555', 'foto_siti.jpg'),
('2023003', 'Rudi Hermawan', '320100000000003', 'L', 'Surabaya', '1996-03-10', '08122233344', 'rudi@kantor.com', 'Jl. Melati No. 10', 'Tidak Kawin', 0, 'D3', '2022-05-01', 'Tetap', 4, 1, 'FIN01', 'TK/0', '33.444.555.6', '000555666', '666777888', 'foto_rudi.jpg'),
('2023004', 'Dewi Sartika', '320100000000004', 'P', 'Yogyakarta', '1998-12-25', '08155566677', 'dewi@kantor.com', 'Jl. Anggrek No. 3', 'Kawin', 1, 'S1', '2023-01-15', 'Kontrak', 5, 1, 'HR01', 'K/1', '44.555.666.7', '000777888', '888999000', 'foto_dewi.jpg'),
('2023005', 'Eko Prasetyo', '320100000000005', 'L', 'Medan', '1997-07-07', '08188899900', 'eko@kantor.com', 'Jl. Mawar No. 99', 'Tidak Kawin', 0, 'S1', '2021-11-20', 'Tetap', 1, 1, 'IT01', 'TK/0', '55.666.777.8', '000999000', '000111222', 'foto_eko.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `lembur`
--

CREATE TABLE `lembur` (
  `id_lembur` int(11) NOT NULL,
  `nip_karyawan` varchar(20) DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `jam_mulai` time DEFAULT NULL,
  `jam_selesai` time DEFAULT NULL,
  `alasan` text DEFAULT NULL,
  `status_persetujuan` enum('Menunggu','Disetujui','Ditolak') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lembur`
--

INSERT INTO `lembur` (`id_lembur`, `nip_karyawan`, `tanggal`, `jam_mulai`, `jam_selesai`, `alasan`, `status_persetujuan`) VALUES
(1, '2023002', '2025-07-20', '17:00:00', '20:00:00', 'Kejar Deadline Project', 'Disetujui'),
(2, '2023001', '2025-07-31', '17:00:00', '21:00:00', 'Tutup Buku Bulanan', 'Disetujui'),
(3, '2023005', '2025-07-10', '18:00:00', '21:00:00', 'Maintenance Server', 'Disetujui');

-- --------------------------------------------------------

--
-- Table structure for table `level_jabatan`
--

CREATE TABLE `level_jabatan` (
  `id_level` int(11) NOT NULL,
  `nama_level` varchar(50) NOT NULL,
  `gaji_minimal` decimal(15,2) DEFAULT NULL,
  `gaji_maksimal` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `level_jabatan`
--

INSERT INTO `level_jabatan` (`id_level`, `nama_level`, `gaji_minimal`, `gaji_maksimal`) VALUES
(1, 'Junior', 3000000.00, 5000000.00),
(2, 'Middle', 5000000.00, 8000000.00),
(3, 'Senior', 8000000.00, 15000000.00);

-- --------------------------------------------------------

--
-- Table structure for table `penggajian`
--

CREATE TABLE `penggajian` (
  `id_gaji` int(11) NOT NULL,
  `nip_karyawan` varchar(20) DEFAULT NULL,
  `periode_gaji` varchar(20) DEFAULT NULL,
  `gaji_pokok` decimal(15,2) DEFAULT NULL,
  `total_lembur` decimal(15,2) DEFAULT NULL,
  `tunjangan_keluarga` decimal(15,2) DEFAULT NULL,
  `potongan_bpjs` decimal(15,2) DEFAULT NULL,
  `potongan_pajak` decimal(15,2) DEFAULT NULL,
  `total_penambah` decimal(15,2) DEFAULT NULL,
  `total_pengurang` decimal(15,2) DEFAULT NULL,
  `total_gaji_diterima` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penggajian`
--

INSERT INTO `penggajian` (`id_gaji`, `nip_karyawan`, `periode_gaji`, `gaji_pokok`, `total_lembur`, `tunjangan_keluarga`, `potongan_bpjs`, `potongan_pajak`, `total_penambah`, `total_pengurang`, `total_gaji_diterima`) VALUES
(1, '2023002', 'Juli 2025', 4000000.00, 500000.00, 0.00, 100000.00, 50000.00, 4500000.00, 150000.00, 4350000.00),
(2, '2023002', 'Juli 2025', 4000000.00, 500000.00, 0.00, 100000.00, 50000.00, 4500000.00, 150000.00, 4350000.00),
(3, '2023001', 'Juli 2025', 10000000.00, 1000000.00, 1500000.00, 200000.00, 500000.00, 12500000.00, 700000.00, 11800000.00),
(4, '2023003', 'Juli 2025', 4500000.00, NULL, NULL, NULL, NULL, NULL, NULL, 4850000.00),
(5, '2023004', 'Juli 2025', 4200000.00, NULL, NULL, NULL, NULL, NULL, NULL, 4100000.00),
(6, '2023005', 'Juli 2025', 4000000.00, NULL, NULL, NULL, NULL, NULL, NULL, 4600000.00);

-- --------------------------------------------------------

--
-- Table structure for table `penilaian_kinerja`
--

CREATE TABLE `penilaian_kinerja` (
  `id_penilaian` int(11) NOT NULL,
  `nip_karyawan` varchar(20) DEFAULT NULL,
  `periode_penilaian` varchar(20) DEFAULT NULL,
  `nilai_disiplin` int(11) DEFAULT NULL,
  `nilai_produktivitas` int(11) DEFAULT NULL,
  `nilai_inisiatif` int(11) DEFAULT NULL,
  `nilai_kerjasama` int(11) DEFAULT NULL,
  `nilai_komunikasi` int(11) DEFAULT NULL,
  `nilai_akhir_skor` decimal(5,2) DEFAULT NULL,
  `predikat_kinerja` varchar(20) DEFAULT NULL,
  `catatan_manajer` text DEFAULT NULL,
  `bonus_kinerja` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penilaian_kinerja`
--

INSERT INTO `penilaian_kinerja` (`id_penilaian`, `nip_karyawan`, `periode_penilaian`, `nilai_disiplin`, `nilai_produktivitas`, `nilai_inisiatif`, `nilai_kerjasama`, `nilai_komunikasi`, `nilai_akhir_skor`, `predikat_kinerja`, `catatan_manajer`, `bonus_kinerja`) VALUES
(1, '2023002', 'Jan-Jun 2025', 4, 5, 4, 5, 4, 4.40, 'Baik', 'Kinerja sangat memuaskan', 2000000.00),
(2, '2023002', 'Jan-Jun 2025', 4, 5, 4, 5, 4, 4.40, 'Baik', 'Kinerja sangat memuaskan', 2000000.00),
(3, '2023001', 'Jan-Jun 2025', 5, 5, 5, 4, 5, 4.80, 'Sangat Baik', 'Leadership sangat kuat', 5000000.00),
(4, '2023003', 'Jan-Jun 2025', NULL, NULL, NULL, NULL, NULL, 4.20, 'Baik', 'Teliti dalam hitungan', 1500000.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `rekap_karyawan_lengkap`
-- (See below for the actual view)
--
CREATE TABLE `rekap_karyawan_lengkap` (
`nip` varchar(20)
,`nama_lengkap` varchar(100)
,`foto_path` varchar(255)
,`nama_departemen` varchar(100)
,`nama_jabatan` varchar(100)
,`nama_level` varchar(50)
,`no_hp` varchar(15)
,`email` varchar(100)
);

-- --------------------------------------------------------

--
-- Structure for view `rekap_karyawan_lengkap`
--
DROP TABLE IF EXISTS `rekap_karyawan_lengkap`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `rekap_karyawan_lengkap`  AS SELECT `k`.`nip` AS `nip`, `k`.`nama_lengkap` AS `nama_lengkap`, `k`.`foto_path` AS `foto_path`, `d`.`nama_departemen` AS `nama_departemen`, `j`.`nama_jabatan` AS `nama_jabatan`, `l`.`nama_level` AS `nama_level`, `k`.`no_hp` AS `no_hp`, `k`.`email` AS `email` FROM (((`karyawan` `k` join `departemen` `d` on(`k`.`kode_departemen` = `d`.`kode_departemen`)) join `jabatan` `j` on(`k`.`id_jabatan` = `j`.`id_jabatan`)) join `level_jabatan` `l` on(`k`.`id_level_jabatan` = `l`.`id_level`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `absensi`
--
ALTER TABLE `absensi`
  ADD PRIMARY KEY (`id_absensi`),
  ADD KEY `nip_karyawan` (`nip_karyawan`);

--
-- Indexes for table `cuti`
--
ALTER TABLE `cuti`
  ADD PRIMARY KEY (`id_cuti`),
  ADD KEY `nip_karyawan` (`nip_karyawan`);

--
-- Indexes for table `departemen`
--
ALTER TABLE `departemen`
  ADD PRIMARY KEY (`kode_departemen`),
  ADD KEY `nip_kepala` (`nip_kepala`);

--
-- Indexes for table `jabatan`
--
ALTER TABLE `jabatan`
  ADD PRIMARY KEY (`id_jabatan`),
  ADD KEY `id_level_default` (`id_level_default`);

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`nip`),
  ADD KEY `id_jabatan` (`id_jabatan`),
  ADD KEY `id_level_jabatan` (`id_level_jabatan`),
  ADD KEY `kode_departemen` (`kode_departemen`);

--
-- Indexes for table `lembur`
--
ALTER TABLE `lembur`
  ADD PRIMARY KEY (`id_lembur`),
  ADD KEY `nip_karyawan` (`nip_karyawan`);

--
-- Indexes for table `level_jabatan`
--
ALTER TABLE `level_jabatan`
  ADD PRIMARY KEY (`id_level`);

--
-- Indexes for table `penggajian`
--
ALTER TABLE `penggajian`
  ADD PRIMARY KEY (`id_gaji`),
  ADD KEY `nip_karyawan` (`nip_karyawan`);

--
-- Indexes for table `penilaian_kinerja`
--
ALTER TABLE `penilaian_kinerja`
  ADD PRIMARY KEY (`id_penilaian`),
  ADD KEY `nip_karyawan` (`nip_karyawan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absensi`
--
ALTER TABLE `absensi`
  MODIFY `id_absensi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `cuti`
--
ALTER TABLE `cuti`
  MODIFY `id_cuti` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `jabatan`
--
ALTER TABLE `jabatan`
  MODIFY `id_jabatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `lembur`
--
ALTER TABLE `lembur`
  MODIFY `id_lembur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `level_jabatan`
--
ALTER TABLE `level_jabatan`
  MODIFY `id_level` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `penggajian`
--
ALTER TABLE `penggajian`
  MODIFY `id_gaji` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `penilaian_kinerja`
--
ALTER TABLE `penilaian_kinerja`
  MODIFY `id_penilaian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `absensi`
--
ALTER TABLE `absensi`
  ADD CONSTRAINT `absensi_ibfk_1` FOREIGN KEY (`nip_karyawan`) REFERENCES `karyawan` (`nip`);

--
-- Constraints for table `cuti`
--
ALTER TABLE `cuti`
  ADD CONSTRAINT `cuti_ibfk_1` FOREIGN KEY (`nip_karyawan`) REFERENCES `karyawan` (`nip`);

--
-- Constraints for table `departemen`
--
ALTER TABLE `departemen`
  ADD CONSTRAINT `departemen_ibfk_1` FOREIGN KEY (`nip_kepala`) REFERENCES `karyawan` (`nip`);

--
-- Constraints for table `jabatan`
--
ALTER TABLE `jabatan`
  ADD CONSTRAINT `jabatan_ibfk_1` FOREIGN KEY (`id_level_default`) REFERENCES `level_jabatan` (`id_level`);

--
-- Constraints for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD CONSTRAINT `karyawan_ibfk_1` FOREIGN KEY (`id_jabatan`) REFERENCES `jabatan` (`id_jabatan`),
  ADD CONSTRAINT `karyawan_ibfk_2` FOREIGN KEY (`id_level_jabatan`) REFERENCES `level_jabatan` (`id_level`),
  ADD CONSTRAINT `karyawan_ibfk_3` FOREIGN KEY (`kode_departemen`) REFERENCES `departemen` (`kode_departemen`);

--
-- Constraints for table `lembur`
--
ALTER TABLE `lembur`
  ADD CONSTRAINT `lembur_ibfk_1` FOREIGN KEY (`nip_karyawan`) REFERENCES `karyawan` (`nip`);

--
-- Constraints for table `penggajian`
--
ALTER TABLE `penggajian`
  ADD CONSTRAINT `penggajian_ibfk_1` FOREIGN KEY (`nip_karyawan`) REFERENCES `karyawan` (`nip`);

--
-- Constraints for table `penilaian_kinerja`
--
ALTER TABLE `penilaian_kinerja`
  ADD CONSTRAINT `penilaian_kinerja_ibfk_1` FOREIGN KEY (`nip_karyawan`) REFERENCES `karyawan` (`nip`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
