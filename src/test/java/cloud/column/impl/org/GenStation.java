package cloud.column.impl.org;

import cloud.column.GenTableColumnService;
import com.tangyh.lamp.generator.model.GenTableColumn;
import com.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static com.tangyh.lamp.generator.model.GenTableColumn.NO;
import static com.tangyh.lamp.generator.model.GenTableColumn.YES;

/**
 * @author tangyh
 * @version v1.0
 * @date 2021/5/13 12:31 下午
 * @create [2021/5/13 12:31 下午 ] [tangyh] [初始创建]
 */
public class GenStation implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("name", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));

        //表名
        map.put("c_station", keyField);

        return map;
    }
}
