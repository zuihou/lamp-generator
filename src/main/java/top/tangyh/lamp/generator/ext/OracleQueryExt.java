package top.tangyh.lamp.generator.ext;

import com.baomidou.mybatisplus.generator.config.querys.OracleQuery;

/**
 * 扩展 {@link OracleQuery}  方便加入sql查询表元数据信息 增加自定义列，辅助我们的检验器的自动生成
 *
 * @author zuihou
 * @date 2020年01月19日10:23:23
 */
public class OracleQueryExt extends OracleQuery {

    @Override
    public String[] fieldCustom() {
        return new String[]{"NULLABLE", "DATA_SCALE"};
    }

    @Override
    public String tableFieldsSql() {
        return "SELECT A.COLUMN_NAME, CASE WHEN A.DATA_TYPE='NUMBER' THEN "
                + "(CASE WHEN A.DATA_PRECISION IS NULL THEN A.DATA_TYPE "
                + "WHEN NVL(A.DATA_SCALE, 0) > 0 THEN A.DATA_TYPE||'('||A.DATA_PRECISION||','||A.DATA_SCALE||')' "
                + "ELSE A.DATA_TYPE||'('||A.DATA_PRECISION||')' END) "
                + "ELSE A.DATA_TYPE END DATA_TYPE, B.COMMENTS,DECODE(C.POSITION, '1', 'PRI') KEY "
                + ", A.NULLABLE, A.DATA_SCALE "
                + "FROM ALL_TAB_COLUMNS A "
                + " INNER JOIN ALL_COL_COMMENTS B ON A.TABLE_NAME = B.TABLE_NAME AND A.COLUMN_NAME = B.COLUMN_NAME AND B.OWNER = '#schema'"
                + " LEFT JOIN ALL_CONSTRAINTS D ON D.TABLE_NAME = A.TABLE_NAME AND D.CONSTRAINT_TYPE = 'P' AND D.OWNER = '#schema'"
                + " LEFT JOIN ALL_CONS_COLUMNS C ON C.CONSTRAINT_NAME = D.CONSTRAINT_NAME AND C.COLUMN_NAME=A.COLUMN_NAME AND C.OWNER = '#schema'"
                + "WHERE A.OWNER = '#schema' AND A.TABLE_NAME = '%s' ORDER BY A.COLUMN_ID ";
    }
}
