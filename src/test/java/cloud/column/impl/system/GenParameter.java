package cloud.column.impl.system;

import cloud.column.GenTableColumnService;
import com.tangyh.lamp.generator.model.GenTableColumn;
import com.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static com.tangyh.lamp.generator.model.GenTableColumn.NO;
import static com.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenParameter implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("key_", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("value", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("name", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("describe_", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));

        //表名
        map.put("c_parameter", keyField);

        return map;
    }
}
