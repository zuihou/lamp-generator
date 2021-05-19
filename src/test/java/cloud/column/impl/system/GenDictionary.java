package cloud.column.impl.system;

import cloud.column.GenTableColumnService;
import com.tangyh.lamp.generator.model.GenTableColumn;
import com.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static com.tangyh.lamp.generator.model.GenTableColumn.NO;
import static com.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenDictionary implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("parent_id", new GenTableColumn(YES, NO, NO));
        keyField.put("key", new GenTableColumn(YES, YES, YES));
        keyField.put("name", new GenTableColumn(YES, YES, YES));
        keyField.put("item_key", new GenTableColumn(NO, NO, NO));
        keyField.put("item_name", new GenTableColumn(NO, NO, NO));
        keyField.put("state", new GenTableColumn(YES, YES, NO));
        keyField.put("describe_", new GenTableColumn(NO, NO, NO));
        keyField.put("sort_value", new GenTableColumn(NO, NO, NO));
        keyField.put("icon", new GenTableColumn(NO, NO, NO));
        keyField.put("css_style", new GenTableColumn(NO, NO, NO));
        keyField.put("css_class", new GenTableColumn(NO, NO, NO));
        keyField.put("readonly_", new GenTableColumn(NO, NO, NO));

        //表名
        map.put("c_dict", keyField);

        return map;
    }
}
