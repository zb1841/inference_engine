inference_engine
================

a simple chinese inference engine

http://user.qzone.qq.com/75926462/2

online demo   :
http://144.npulse.cn/tuiliji/

在示例中：
有3部分。
事实部分根据大数据抽取，可以使用任何parser生成 可以信赖的n tuple 元组命题，例如：

青菜 是 绿色
白菜 属于 青菜
小象 可能是 大象
小象 属于 幼崽
河马 喜欢 大象
小刚 喜欢 打球
小刚 喜欢 刘翔
小刚 喜欢 林书豪 |0.7
小明 玩篮球
河马 特别 喜欢 洗澡

自然语言应用中需要处理的逻辑推理工作，抽象出来，用蕴含算子（见前几天日志）映射到一组新的关系函数。
。
"|0.7" 代表该事实/规则的概率是0.7,概率乘积为最后结论的概率

第二部分：规则，可以通过人工根据项目/业务需求人工定义，或者使用机器学习/统计算法生成。例如：


$a 是 绿色 && $b 属于 $a => $b 是 绿色 |0.9
$a 属于 $b && $b 是 颜色~0.2 => $a 有 颜色
$c 可能是 $b && $c 属于 宠物~0.3 => $b
$a 喜欢 $b &&  $c 可能是 $b && $c 属于 幼崽 => $c 可能是 $b
$a 喜欢 打球 && $a 喜欢 姚明~0.1 && $a 喜欢 $b => $b 可能像 姚明
$a  打篮球~0.02 => $a 是体育迷
$a  $b $c $d => $d


符号“=>”表示”推理“，符号左边的模版，推理出右边的结论，前边的模版将匹配所有第一部分列出的所有事实。制定的实体、概念可以是模糊的。用”~“限定相似度。&&符号表示并列，即多个条件并列起来. "|0.9" 表示该规则概率为0.9，规则和事实的概率乘积决定结果概率


第三部分：机器生成的结论 

白菜 是 绿色  |0.9
白菜 有 颜色  |1
小象 可能是 大象  |1
刘翔 可能像 姚明  |0.7
林书豪 可能像 姚明  |0.7
小明 是体育迷  |1
洗澡  |1


 

规则文件中的 "颜色~0.2"   意思是 事实中实体词距离 "颜色" 余弦距离大于0.2的所有词 

在应用中 可以将结果经过格式化后输出到事实文件中，进行多次迭代推理

fmp/fmt的模糊推理都可以实现，即机器人可以做填空题，和判断题。
