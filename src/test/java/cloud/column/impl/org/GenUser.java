package cloud.column.impl.org;

import cloud.column.GenTableColumnService;
import top.tangyh.lamp.generator.model.GenTableColumn;
import top.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static top.tangyh.lamp.generator.model.GenTableColumn.NO;
import static top.tangyh.lamp.generator.model.GenTableColumn.YES;

/**
 * @author tangyh
 * @version v1.0
 * @date 2021/5/13 12:31 下午
 * @create [2021/5/13 12:31 下午 ] [tangyh] [初始创建]
 */
public class GenUser implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("account", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("name", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));

        keyField.put("sex", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setEnumType("Sex"));
        keyField.put("nation", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setDictType("NATION"));
        keyField.put("education", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setDictType("EDUCATION"));
        keyField.put("position_status", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setDictType("POSITION_STATUS"));
        keyField.put("readonly", new GenTableColumn(NO, NO, NO));
        keyField.put("password_error_last_time", new GenTableColumn(NO, NO, NO));
        keyField.put("password_error_num", new GenTableColumn(NO, NO, NO));
        keyField.put("password_expire_time", new GenTableColumn(NO, NO, NO));
        keyField.put("password", new GenTableColumn(NO, NO, NO));
        keyField.put("salt", new GenTableColumn(NO, NO, NO));
        keyField.put("last_login_time", new GenTableColumn(NO, NO, NO));
        //表名
        map.put("c_user", keyField);

        return map;
    }
}
