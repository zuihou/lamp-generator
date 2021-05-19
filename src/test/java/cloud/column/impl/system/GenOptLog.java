package cloud.column.impl.system;

import cloud.column.GenTableColumnService;
import com.tangyh.lamp.generator.model.GenTableColumn;
import com.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static com.tangyh.lamp.generator.model.GenTableColumn.NO;
import static com.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenOptLog implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("http_method", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setEnumType("HttpMethod"));
        keyField.put("type", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setEnumType("LogType"));

        //表名
        map.put("c_opt_log", keyField);

        return map;
    }
}
