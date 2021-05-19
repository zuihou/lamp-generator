package cloud.column.impl.system;

import cloud.column.GenTableColumnService;
import com.tangyh.lamp.generator.model.GenTableColumn;
import com.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static com.tangyh.lamp.generator.model.GenTableColumn.NO;
import static com.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenRole implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("name", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("code", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("ds_type", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setEnumType("DataScopeType"));

        //表名
        map.put("c_role", keyField);

        return map;
    }
}
