package dal;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class InventoryDAO extends DBContext {

    public List<Map<String, Object>> getInventoryReport(
            String productCode,
            String productName,
            Date startDate,
            Date endDate,
            int pageIndex,
            int pageSize) {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
            WITH ChangeSummary AS (
                SELECT 
                    pc.product_id,
                    MIN(pc.change_date) as first_change_date,
                    MAX(CASE 
                        WHEN pc.rn_first = 1 THEN pc.before_change 
                        ELSE NULL 
                    END) as beginning_from_changes,
                    COALESCE(SUM(CASE 
                        WHEN pc.change_amount > 0 THEN pc.change_amount 
                        ELSE 0 
                    END), 0) as import_period,
                    COALESCE(SUM(CASE 
                        WHEN pc.change_amount < 0 THEN ABS(pc.change_amount) 
                        ELSE 0 
                    END), 0) as export_period,
                    MAX(CASE 
                        WHEN pc.rn_last = 1 THEN pc.after_change 
                        ELSE NULL 
                    END) as latest_after_change
                FROM (
                    SELECT 
                        pc1.product_id,
                        pc1.change_date,
                        pc1.before_change,
                        pc1.after_change,
                        pc1.change_amount,
                        ROW_NUMBER() OVER (
                            PARTITION BY pc1.product_id 
                            ORDER BY pc1.change_date ASC, pc1.created_at ASC
                        ) as rn_first,
                        ROW_NUMBER() OVER (
                            PARTITION BY pc1.product_id 
                            ORDER BY pc1.change_date DESC, pc1.created_at DESC
                        ) as rn_last
                    FROM product_change pc1
                    WHERE pc1.change_date >= ? 
                        AND pc1.change_date <= ?
                ) pc
                GROUP BY pc.product_id
            ),
            ProductBase AS (
                SELECT 
                    p.id,
                    p.productCode,
                    p.name,
                    p.categoryId,
                    p.unit as current_unit,
                    p.status,
                    c.categoryName,
                    COALESCE(cs.beginning_from_changes, p.unit) as beginning_inventory,
                    COALESCE(cs.import_period, 0) as import_period,
                    COALESCE(cs.export_period, 0) as export_period,
                    CASE 
                        WHEN cs.latest_after_change IS NOT NULL THEN cs.latest_after_change
                        ELSE p.unit
                    END as ending_inventory
                FROM product p
                LEFT JOIN category c ON p.categoryId = c.categoryId
                LEFT JOIN ChangeSummary cs ON p.id = cs.product_id
                WHERE (? IS NULL OR p.productCode LIKE ?)
                    AND (? IS NULL OR p.name LIKE ?)
            )
            SELECT * FROM ProductBase
            ORDER BY id ASC
            LIMIT ? OFFSET ?
            """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            ps.setDate(idx++, startDate);
            ps.setDate(idx++, endDate);

            if (productCode != null && !productCode.trim().isEmpty()) {
                ps.setString(idx++, "%" + productCode.trim() + "%");
            } else {
                ps.setNull(idx++, Types.VARCHAR);
            }

            if (productCode != null && !productCode.trim().isEmpty()) {
                ps.setString(idx++, "%" + productCode.trim() + "%");
            } else {
                ps.setNull(idx++, Types.VARCHAR);
            }

            if (productName != null && !productName.trim().isEmpty()) {
                ps.setString(idx++, "%" + productName.trim() + "%");
            } else {
                ps.setNull(idx++, Types.VARCHAR);
            }

            if (productName != null && !productName.trim().isEmpty()) {
                ps.setString(idx++, "%" + productName.trim() + "%");
            } else {
                ps.setNull(idx++, Types.VARCHAR);
            }

            int offset = (pageIndex - 1) * pageSize;
            ps.setInt(idx++, pageSize);
            ps.setInt(idx++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("id", rs.getInt("id"));
                    item.put("productCode", rs.getString("productCode"));
                    item.put("name", rs.getString("name"));
                    item.put("categoryName", rs.getString("categoryName"));
                    item.put("beginning_inventory", rs.getInt("beginning_inventory"));
                    item.put("import_period", rs.getInt("import_period"));
                    item.put("export_period", rs.getInt("export_period"));
                    item.put("ending_inventory", rs.getInt("ending_inventory"));
                    item.put("status", rs.getString("status"));

                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countInventoryReport(
            String productCode,
            String productName,
            Date startDate,
            Date endDate) {

        int total = 0;

        String sql = """
            SELECT COUNT(p.id)
            FROM product p
            WHERE (? IS NULL OR p.productCode LIKE ?)
                AND (? IS NULL OR p.name LIKE ?)
            """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;

            if (productCode != null && !productCode.trim().isEmpty()) {
                ps.setString(idx++, "%" + productCode.trim() + "%");
            } else {
                ps.setNull(idx++, Types.VARCHAR);
            }

            if (productCode != null && !productCode.trim().isEmpty()) {
                ps.setString(idx++, "%" + productCode.trim() + "%");
            } else {
                ps.setNull(idx++, Types.VARCHAR);
            }

            if (productName != null && !productName.trim().isEmpty()) {
                ps.setString(idx++, "%" + productName.trim() + "%");
            } else {
                ps.setNull(idx++, Types.VARCHAR);
            }

            if (productName != null && !productName.trim().isEmpty()) {
                ps.setString(idx++, "%" + productName.trim() + "%");
            } else {
                ps.setNull(idx++, Types.VARCHAR);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
}