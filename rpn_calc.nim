import std/strutils
import nimib
#import ./theme/codeOutput

var nbToc: NbBlock

template addToc =
  newNbBlock("nbText", false, nb, nbToc, ""):
    nbToc.output = "## 目录:\n\n"

template nbNewSection(name:string) =
  let anchorName = name.toLower.replace(" ", "-")
  nbText "<a name=\"" & anchorName & "\"></a>"
  nbText "<br>"
  nbText "### " & name & ""
  nbText "<hr />"
  nbToc.output.add "1. <a href=\"#" & anchorName & "\">" & name & "</a>\n"

template nbSubSection(name:string) =
  let anchorName = name.toLower.replace(" ", "-")
  nbText "<a name=\"" & anchorName & "\"></a>"
  nbText "<br>"
  nbText "#### " & name & ""
  nbText "<hr />"
  nbToc.output.add "    * <a href=\"#" & anchorName & "\">" & name & "</a>\n"

nbInit
#initCodeTheme()

nbText: """
<h1>《RPN计算器使用说明》</h1>
<ul>
<li>作者：王凌</li>
<li>版本：2.1.1</li>
</ul>
"""

# 生成目录
addToc

# 1. 功能概述章节
nbNewSection "功能概述"

nbText: """
<p>RPN计算器是一个基于逆波兰表示法（Reverse Polish Notation）的命令行计算工具，具有以下核心功能：</p>

<h4>主要特性</h4>
<ul>
<li><strong>逆波兰表示法</strong>：采用后缀表达式，无需括号即可处理复杂运算优先级</li>
<li><strong>丰富的数学运算</strong>：支持四则运算、幂运算、平方根、斐波那契数列、杨辉三角等</li>
<li><strong>栈式操作</strong>：基于栈的数据结构，自动保存中间计算结果</li>
<li><strong>完善的错误处理</strong>：提供清晰的错误提示和异常处理机制</li>
<li><strong>跨平台支持</strong>：兼容Linux、macOS、Windows操作系统</li>
<li><strong>批量处理功能</strong>：支持从文件读取表达式进行批量计算</li>
</ul>

<h4>技术特点</h4>
<ul>
<li>使用C++11标准编写，代码简洁高效</li>
<li>无外部依赖，纯标准库实现</li>
<li>支持整数和浮点数混合运算</li>
<li>提供栈查看、清空等管理功能</li>
</ul>
"""

# 2. 安装和编译指南
nbNewSection "安装和编译指南"

nbText: """
<p>系统要求<br>
操作系统：Ubuntu 20.04 及以上版本，或任何支持g++的Linux发行版<br>
依赖工具：g++ 编译器</p>
"""

nbCode:
  discard """
安装依赖
# 更新软件源
sudo apt update

# 安装g++编译器
sudo apt install -y g++

# 验证安装
g++ --version
"""

nbText: """
<p>编译程序<br>
将源代码保存为rpn_calc.cpp后，执行以下命令编译：</p>
"""

nbCode:
  discard """
# 编译源码
g++ -std=c++11 -o rpn_calc rpn_calc.cpp

# 运行计算器
./rpn_calc
"""

# 3. 基本使用示例
nbNewSection "基本使用示例"

nbText: """
<p>RPN计算器使用逆波兰表示法，不需要括号，运算顺序由输入顺序决定。</p>

<h4>基本使用流程</h4>
<ul>
<li>输入数字，按空格分隔</li>
<li>输入运算符进行计算</li>
<li>计算器自动显示结果</li>
<li>使用特殊命令管理计算过程</li>
</ul>

<h4>简单示例</h4>
"""

nbCode:
  discard """
# 启动计算器
./rpn_calc

# 基本运算
RPN Calculator > 3 5 +
结果: 8

RPN Calculator > 10 4 -
结果: 6

RPN Calculator > 2 4 + 3 *
结果: 18
"""

# 4. 所有支持的操作说明
nbNewSection "所有支持的操作说明"

nbText: """
<h4>基本四则运算</h4>
"""

nbCode:
  discard """
> 5 3 +
结果: 8
> 10 4 -
结果: 6
> 6 7 *
结果: 42
> 15 2 /
结果: 7.5
"""

nbText: """
<h4>高级数学运算</h4>
"""

nbCode:
  discard """
> 16 sqrt
结果: 4
> 2 5 ^
结果: 32
> 7 fib
结果: 13
> 5 2 pascal
结果: 10
"""

nbText: """
<h4>栈操作命令</h4>
"""

nbCode:
  discard """
> 5 3 7
> display
当前栈：5 3 7
> clear
栈已清空
> display
当前栈：空
"""

nbText: """
<h4>其他命令</h4>
<ul>
<li><code>help</code> - 显示帮助信息</li>
<li><code>q</code> / <code>quit</code> - 退出程序</li>
</ul>
"""

# 5. 错误代码和异常说明
nbNewSection "错误代码和异常说明"

nbText: """
<h4>常见错误类型</h4>
"""

nbText: """
<p>栈为空错误</p>
"""

nbCode:
  discard """
> +
错误: 栈为空
> 4 6 +
结果: 10
"""

nbText: """
<p>除零错误</p>
"""

nbCode:
  discard """
> 10 0 /
错误: 除零
> 10 2 /
结果: 5.0
"""

nbText: """
<p>无效操作符错误</p>
"""

nbCode:
  discard """
> 7 2 #
错误: 无效操作符
> 7 2 *
结果: 14
"""

nbText: """
<p>栈不足错误</p>
"""

nbCode:
  discard """
> 5 *
错误: 栈不足
> 5 3 *
结果: 15
"""

nbText: """
<p>无效数字错误</p>
"""

nbCode:
  discard """
> abc 3 +
错误: 无效数字
> 4.5 3 +
结果: 7.5
"""

# 6. 示例输入输出
nbNewSection "示例输入输出"

nbText: """
<p>完整的使用示例：</p>
"""

nbCode:
  discard """
# 启动程序
./rpn_calc

# 基本运算
RPN Calculator > 12 8 +
结果: 20

RPN Calculator > 5 *
结果: 100

# 高级函数
RPN Calculator > sqrt
结果: 10.0

# 栈管理
RPN Calculator > display
当前栈：10.0

# 错误处理
RPN Calculator > 0 /
错误: 除零

# 清空栈
RPN Calculator > clear
栈已清空

# 数学序列
RPN Calculator > 8 fib
结果: 21

RPN Calculator > 6 3 pascal
结果: 20

# 获取帮助
RPN Calculator > help
================= RPN 计算器帮助 =================
支持操作符：+（加）、-（减）、*（乘）、/（除）、sqrt（平方根）、^（幂运算）、fib（斐波那契）、pascal（杨辉三角）
特殊命令：clear（清空栈）、display（显示栈）、help（查看帮助）、q/quit（退出）
输入规则：操作数与运算符用空格分隔，按回车计算
================================================

# 退出程序
RPN Calculator > q
再见!
"""

# 7. 使用技巧和注意事项
nbNewSection "使用技巧和注意事项"

nbText: """
<h4>使用技巧</h4>

<p><strong>分步计算复杂表达式</strong><br>
对于复杂公式如 <code>(3 + 4) * (6 - 2) / 2</code>，可分步输入：</p>
"""

nbCode:
  discard """
RPN Calculator > 3 4 +
结果: 7
RPN Calculator > 6 2 -
结果: 4
RPN Calculator > *
结果: 28
RPN Calculator > 2 /
结果: 14.0
"""

nbText: """
<p><strong>利用栈保存中间结果</strong><br>
栈会自动保留未参与后续运算的结果：</p>
"""

nbCode:
  discard """
RPN Calculator > 10 5 +
结果: 15
RPN Calculator > 3 *
结果: 45
"""

nbText: """
<h4>注意事项</h4>
<ul>
<li>操作数与运算符必须用<strong>空格分隔</strong></li>
<li>支持整数和浮点数混合运算，结果以浮点数形式显示</li>
<li>斐波那契数参数建议不超过40</li>
<li>杨辉三角行数建议不超过30</li>
<li>程序退出后不保存历史记录</li>
</ul>
"""

nbSave

