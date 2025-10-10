import std/strutils
import nimib
import ./theme/codeOutput

var nbToc: NbBlock

template addToc =
  newNbBlock("nbText", false, nb, nbToc, ""):
    nbToc.output = "## 目录:\n\n"

template nbNewSection(name:string) =
  let anchorName = name.toLower.replace(" ", "-")
  nbText "<a name=\"" & anchorName & "\"></a>\n<br>\n### " & name & "\n\n---"
  nbToc.output.add "1. <a href=\"#" & anchorName & "\">" & name & "</a>\n"

template nbSubSection(name:string) =
  let anchorName = name.toLower.replace(" ", "-")
  nbText "<a name=\"" & anchorName & "\"></a>\n<br>\n#### " & name & "\n\n---"
  nbToc.output.add "    * <a href=\"#" & anchorName & "\">" & name & "</a>\n"

template nbQuoteBlock(code: untyped) =
  nbText "<blockquote>"
  code
  nbText "</blockquote>"

nbInit
initCodeTheme()

nbText: """
《RPN计算器使用说明》
======================================

- 作者：王凌
- 版本：2.1.1
"""

# 生成目录
addToc
nbText nbToc.output
nbText "<br>\n"

# 1. 安装编译章节
nbNewSection "安装编译"

nbText: """
要使用 RPN 计算器，需先通过 g++ 编译源码，具体步骤如下：

### 编译命令

在终端进入源码所在目录，执行以下命令编译（需确保系统已安装 g++ 且支持 C++11 标准）：
"""

nbCode:
  # 编译源码，生成可执行文件 rpn_calc
  g++ -std=c++11 -o rpn_calc rpn_calc.cpp
  
  # 运行计算器（Linux/macOS 系统）
  ./rpn_calc
  
  # 运行计算器（Windows 系统，需在命令提示符中执行）
  rpn_calc.exe

nbText: """
### 依赖说明

* 编译器：g++ 4.8 及以上版本（或其他支持 C++11 的编译器）
* 系统：无特殊依赖，支持 Linux、macOS、Windows 主流操作系统
"""

# 2. 快速开始章节
nbNewSection "快速开始"

nbSubSection "启动与交互界面"

nbText: """
启动计算器后，终端会显示以下提示符，代表程序已就绪，可输入 RPN 表达式：
"""

nbCode:
  RPN Calculator > 

nbText: """
### 基本输入规则

* 操作数（数字）与运算符之间需用 **空格分隔**
* 支持整数和浮点数输入（如 `3`、`5.2`）
* 输入完成后按回车键，程序会立即计算并输出结果
"""

nbSubSection "首次使用示例"

nbQuoteBlock:
  nbText "计算\"3 + 5\"的 RPN 表达式（RPN 格式为\"3 5 +\"）："
  nbCode:
    RPN Calculator > 3 5 +
    结果: 8
  
  nbText "计算\"(2 + 4) * 3\"的 RPN 表达式（RPN 格式为\"2 4 + 3 *\"）："
  nbCode:
    RPN Calculator > 2 4 + 3 *
    结果: 18

# 3. 支持的操作符章节
nbNewSection "支持的操作符"

nbText: """
下表详细列出了计算器支持的所有操作符，包括功能说明、所需操作数数量及使用示例：

| 操作符      | 功能描述               | 所需操作数 | 使用示例         | 计算结果 |
| -------- | ------------------ | ----- | ------------ | ---- |
| `+`      | 加法（两数相加）           | 2     | `5 3 +`      | 8    |
| `-`      | 减法（前数减后数）          | 2     | `10 4 -`     | 6    |
| `*`      | 乘法（两数相乘）           | 2     | `6 7 *`      | 42   |
| `/`      | 除法（前数除后数，浮点数）      | 2     | `15 2 /`     | 7.5  |
| `sqrt`   | 平方根（单个数字的平方根）      | 1     | `16 sqrt`    | 4    |
| `^`      | 幂运算（前数的后数次方）       | 2     | `2 5 ^`      | 32   |
| `fib`    | 斐波那契数（第 n 个斐波那契数）  | 1     | `7 fib`      | 13   |
| `pascal` | 杨辉三角（第 n 行第 k 列数值） | 2     | `5 2 pascal` | 10   |

> 注意：斐波那契数从第 1 项开始计算（`1 fib` 结果为 1，`2 fib` 结果为 1，`3 fib` 结果为 2）
"""

# 4. 特殊命令章节
nbNewSection "特殊命令"

nbText: """
除了计算操作符，计算器还支持以下特殊命令，用于管理计算过程和程序退出：

* `clear`：清空当前栈中所有未计算的操作数，适用于重新开始新计算
"""

nbCode:
  RPN Calculator > 5 3 7  # 栈中存在 5、3、7 三个操作数
  RPN Calculator > clear   # 执行清空命令
  栈已清空
  RPN Calculator > display # 验证栈状态
  当前栈：空

nbText: """
* `display`：显示当前栈中所有操作数（从栈底到栈顶顺序），帮助查看计算中间状态
"""

nbCode:
  RPN Calculator > 10 20 30 +
  结果: 50
  RPN Calculator > display
  当前栈：10 50

nbText: """
* `help`：显示内置帮助信息，包含所有支持的操作符、命令及使用示例
"""

nbCode:
  RPN Calculator > help
  ================= RPN 计算器帮助 =================
  支持操作符：+（加）、-（减）、*（乘）、/（除）、sqrt（平方根）、^（幂运算）、fib（斐波那契）、pascal（杨辉三角）
  特殊命令：clear（清空栈）、display（显示栈）、help（查看帮助）、q/quit（退出）
  输入规则：操作数与运算符用空格分隔，按回车计算
  ================================================

nbText: """
* `q` / `quit`：退出计算器程序，程序会显示告别信息
"""

nbCode:
  RPN Calculator > quit
  再见!

# 5. 错误处理章节
nbNewSection "错误处理与异常说明"

nbText: """
当输入不符合规则或计算过程中出现异常时，程序会输出明确的错误提示，帮助定位问题。常见错误类型如下：

### 1. 栈为空错误

* 错误提示：`错误: 栈为空`
* 触发场景：栈中没有操作数时，执行需要操作数的运算符（如直接输入 `+`）
* 解决方法：先输入足够的操作数，再执行运算符
"""

nbCode:
  RPN Calculator > +  # 栈为空，触发错误
  错误: 栈为空
  RPN Calculator > 4 6 +  # 先输入操作数，再执行运算
  结果: 10

nbText: """
### 2. 除零错误

* 错误提示：`错误: 除零`
* 触发场景：除法运算中，除数为 0（如 `8 0 /`）
* 解决方法：检查除数是否为 0，修改后重新输入
"""

nbCode:
  RPN Calculator > 10 0 /  # 除数为 0，触发错误
  错误: 除零
  RPN Calculator > 10 2 /  # 修正除数，重新计算
  结果: 5.0

nbText: """
### 3. 无效操作符错误

* 错误提示：`错误: 无效操作符`
* 触发场景：输入了不支持的运算符或命令（如 `5 3 #`、`abc`）
* 解决方法：核对支持的操作符列表，确保输入正确
"""

nbCode:
  RPN Calculator > 7 2 #  # 输入无效操作符 #，触发错误
  错误: 无效操作符
  RPN Calculator > 7 2 *  # 修正为支持的操作符 *
  结果: 14

nbText: """
### 4. 栈不足错误

* 错误提示：`错误: 栈不足`
* 触发场景：操作数数量少于运算符需求（如二元运算符需要 2 个操作数，仅输入 1 个）
* 解决方法：补充足够的操作数，再执行运算符
"""

nbCode:
  RPN Calculator > 5 *  # 二元运算符 * 需要 2 个操作数，仅输入 1 个，触发错误
  错误: 栈不足
  RPN Calculator > 5 3 *  # 补充操作数，重新计算
  结果: 15

nbText: """
### 5. 无效数字错误

* 错误提示：`错误: 无效数字`
* 触发场景：输入非数字字符作为操作数（如 `abc 3 +`、`5x 2 *`）
* 解决方法：确保操作数为合法的整数或浮点数，重新输入
"""

nbCode:
  RPN Calculator > abc 3 +  # 输入非数字 abc，触发错误
  错误: 无效数字
  RPN Calculator > 4.5 3 +  # 修正为合法数字 4.5
  结果: 7.5

# 6. 完整示例章节
nbNewSection "完整使用示例"

nbText: """
以下是一个完整的计算器交互流程，涵盖操作数输入、运算、栈管理、错误处理和程序退出，帮助理解实际使用场景：
"""

nbCode:
  # 1. 启动程序，输入操作数并执行加法
  RPN Calculator > 12 8 +
  结果: 20

  # 2. 继续输入操作数，执行乘法（栈中保留 20，新增 5）
  RPN Calculator > 5 *
  结果: 100

  # 3. 执行平方根运算（单个操作数）
  RPN Calculator > sqrt
  结果: 10.0

  # 4. 显示当前栈状态（验证栈中是否只有 10.0）
  RPN Calculator > display
  当前栈：10.0

  # 5. 输入新操作数，尝试除零（触发错误）
  RPN Calculator > 0 /
  错误: 除零

  # 6. 清空栈，重新开始计算
  RPN Calculator > clear
  栈已清空

  # 7. 计算斐波那契数（第 8 个斐波那契数）
  RPN Calculator > 8 fib
  结果: 21

  # 8. 计算杨辉三角第 6 行第 3 列数值
  RPN Calculator > 6 3 pascal
  结果: 20

  # 9. 查看帮助信息
  RPN Calculator > help
  ================= RPN 计算器帮助 =================
  支持操作符：+（加）、-（减）、*（乘）、/（除）、sqrt（平方根）、^（幂运算）、fib（斐波那契）、pascal（杨辉三角）
  特殊命令：clear（清空栈）、display（显示栈）、help（查看帮助）、q/quit（退出）
  输入规则：操作数与运算符用空格分隔，按回车计算
  ================================================

  # 10. 退出程序
  RPN Calculator > q
  再见!

# 7. 使用技巧章节
nbNewSection "使用技巧与注意事项"

nbText: """
### 一、高效计算技巧

1. **分步计算复杂表达式**：对于复杂公式（如 `(3 + 4) * (6 - 2) / 2`），可拆分为分步输入，用 `display` 验证每一步结果：
"""

nbCode:
  # 分步计算 (3+4)*(6-2)/2
  RPN Calculator > 3 4 +    # 第一步：3+4=7
  结果: 7
  RPN Calculator > 6 2 -    # 第二步：6-2=4
  结果: 4
  RPN Calculator > *        # 第三步：7*4=28
  结果: 28
  RPN Calculator > 2 /      # 第四步：28/2=14
  结果: 14.0

nbText: """
2. **利用栈保存中间结果**：无需重复输入已计算的中间值，栈会自动保留未参与后续运算的结果，例如：
"""

nbCode:
  RPN Calculator > 10 5 +  # 计算 10+5=15，栈中保留 15
  结果: 15
  RPN Calculator > 3 *     # 用栈中 15 与新输入的 3 相乘（无需重新输入 15）
  结果: 45

nbText: """
3. **快速修正输入错误**：若输入错误（如输错操作符），可立即执行 `clear` 清空栈，无需退出程序重新启动。

### 二、注意事项

1. **操作数与运算符的分隔**：必须用 **空格** 分隔，否则程序会识别为无效输入（如 `5+3` 会被识别为无效数字，正确应为 `5 3 +`）。

2. **浮点数与整数的兼容性**：计算器支持整数和浮点数混合运算，结果会自动以浮点数形式显示（如 `5 2 /` 结果为 `2.5`，而非 `2`）。

3. **杨辉三角与斐波那契数的参数范围**：
   * 斐波那契数：参数 `n` 建议不超过 40（超过后计算时间会明显增加）
   * 杨辉三角：参数 `n`（行数）建议不超过 30，`k`（列数）需小于 `n`（否则结果为 0）

4. **程序退出的保存**：计算器不保存历史计算记录，退出程序后所有数据会清空，如需保留结果，建议在退出前手动记录。
"""

nbSave

