package cloud.column.impl.system;

import cloud.column.GenTableColumnService;
import cn.hutool.core.util.StrUtil;
import top.tangyh.lamp.generator.model.GenTableColumn;
import top.tangyh.lamp.generator.type.HtmlType;

import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import static top.tangyh.lamp.generator.model.GenTableColumn.NO;
import static top.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenApplication implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("name", new GenTableColumn(YES, YES, YES));
        keyField.put("client_id", new GenTableColumn(YES, YES, NO));
        keyField.put("client_secret", new GenTableColumn(YES, YES, NO));
        keyField.put("website", new GenTableColumn(YES, YES, NO));
        keyField.put("icon", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_Upload));
        keyField.put("app_type", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setEnumType("ApplicationAppTypeEnum"));
        keyField.put("state", new GenTableColumn(YES, YES, NO));

        //表名
        map.put("c_application", keyField);
        return map;
    }
}
