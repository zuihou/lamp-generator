package cloud.column.impl.system;

import cloud.column.GenTableColumnService;
import top.tangyh.lamp.generator.model.GenTableColumn;
import top.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static top.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenArea implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("name", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));

        //表名
        map.put("c_area", keyField);

        return map;
    }
}
