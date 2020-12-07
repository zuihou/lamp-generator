package com.tangyh.lamp.generator.ext;

import com.baomidou.mybatisplus.generator.config.querys.MySqlQuery;

/**
 * 扩展 {@link MySqlQuery}  方便加入sql查询表元数据信息 增加自定义列，辅助我们的检验器的自动生成
 *
 * @author zuihou
 */
public class MySqlQueryExt extends MySqlQuery {

    @Override
    public String[] fieldCustom() {
        return new String[]{"Null", "Default", "Collation"};
    }
}
