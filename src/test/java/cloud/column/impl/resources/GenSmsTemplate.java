package cloud.column.impl.resources;

import cloud.column.GenTableColumnService;
import top.tangyh.lamp.generator.model.GenTableColumn;
import top.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static top.tangyh.lamp.generator.model.GenTableColumn.NO;
import static top.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenSmsTemplate implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        // edit list query
        keyField.put("provider_type", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_API_SELECT).setEnumType("ProviderType"));
        keyField.put("app_id", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_INPUT));
        keyField.put("app_secret", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_INPUT));
        keyField.put("url", new GenTableColumn(YES, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("custom_code", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("name", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("content", new GenTableColumn(YES, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("template_params", new GenTableColumn(NO, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("template_code", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_INPUT));
        keyField.put("sign_name", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("template_describe", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_INPUT));

        //表名
        map.put("e_sms_template", keyField);
        return map;
    }
}
