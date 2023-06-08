/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package table;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import ketnoi.KetNoiSQL;

/**
 *
 * @author COMPUTER
 */
public class PhieuTra {

    public static void insert(String maDocGia, String maSach, String ngayTra) {
        try (
                Connection con = KetNoiSQL.layKetNoi();
                PreparedStatement rs = con.prepareStatement("INSERT INTO PhieuTra VALUES(?, ?, ?)")) {
            rs.setString(1, maDocGia);
            rs.setString(2, maSach);
            rs.setString(3, ngayTra);
            
            rs.executeUpdate();
            
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(PhieuTra.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
    }

}
