#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <cmath>
#include <stdexcept>
#include <iomanip>
#include <limits>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

class RPNCalculator {
private:
    std::vector<double> stack;

    bool isOperator(const std::string& token) {
        return token == "+" || token == "-" || token == "*" || token == "/" ||
               token == "sqrt" || token == "^" || token == "fib" || token == "pascal" ||
               token == "clear" || token == "display";
    }

    double fibonacci(int n) {
        if (n < 0) throw std::invalid_argument("斐波那契数列输入必须为非负数");
        if (n == 0) return 0;
        if (n == 1) return 1;

        double a = 0, b = 1;
        for (int i = 2; i <= n; i++) {
            double temp = a + b;
            a = b;
            b = temp;
        }
        return b;
    }

    double binomialCoefficient(int n, int k) {
        if (k < 0 || k > n) return 0;
        if (k == 0 || k == n) return 1;

        double result = 1;
        for (int i = 1; i <= k; i++) {
            result = result * (n - i + 1) / i;
        }
        return result;
    }

    void handleBinaryOperation(const std::string& op) {
        if (stack.size() < 2) {
            throw std::runtime_error("错误: " + op + " 需要两个操作数");
        }
        double b = pop();
        double a = pop();
        
        if (op == "+") push(a + b);
        else if (op == "-") push(a - b);
        else if (op == "*") push(a * b);
        else if (op == "/") {
            if (b == 0) throw std::runtime_error("错误: 除零错误");
            push(a / b);
        }
        else if (op == "^") push(std::pow(a, b));
    }

    void handleUnaryOperation(const std::string& op) {
        if (stack.empty()) {
            throw std::runtime_error("错误: " + op + " 需要一个操作数");
        }
        double a = pop();
        
        if (op == "sqrt") {
            if (a < 0) throw std::runtime_error("错误: 不能对负数求平方根");
            push(std::sqrt(a));
        }
    }

public:
    RPNCalculator() = default;
    
    void displayStack() const {
        std::cout << "栈内容 [底 -> 顶]: ";
        if (stack.empty()) {
            std::cout << "空";
        } else {
            for (size_t i = 0; i < stack.size(); ++i) {
                // 如果是整数就显示整数，否则显示浮点数
                if (stack[i] == std::floor(stack[i])) {
                    std::cout << static_cast<int>(stack[i]);
                } else {
                    std::cout << std::fixed << std::setprecision(6) << stack[i];
                    std::cout.unsetf(std::ios_base::floatfield); // 重置格式
                }
                if (i != stack.size() - 1) std::cout << " ";
            }
        }
        std::cout << std::endl;
    }

    size_t stackSize() const {
        return stack.size();
    }
    
    void push(double value) {
        stack.push_back(value);
    }

    double pop() {
        if (stack.empty()) {
            throw std::runtime_error("错误: 栈为空");
        }
        double value = stack.back();
        stack.pop_back();
        return value;
    }

    void clear() {
        stack.clear();
        std::cout << "栈已清空" << std::endl;
    }

    void calculate(const std::string& operation) {
        std::istringstream iss(operation);
        std::string token;

        while (iss >> token) {
            if (token == "clear") {
                clear();
                continue;
            }
            else if (token == "display") {
                displayStack();
                continue;
            }

            if (isOperator(token)) {
                if (token == "+" || token == "-" || token == "*" || token == "/" || token == "^") {
                    handleBinaryOperation(token);
                }
                else if (token == "sqrt") {
                    handleUnaryOperation(token);
                }
                else if (token == "fib") {
                    if (stack.empty()) throw std::runtime_error("错误: 斐波那契需要一个操作数");
                    double n = pop();
                    if (n < 0 || n != std::floor(n)) {
                        throw std::runtime_error("错误: 斐波那契输入必须为非负整数");
                    }
                    push(fibonacci(static_cast<int>(n)));
                }
                else if (token == "pascal") {
                    if (stack.size() < 2) throw std::runtime_error("错误: 杨辉三角需要两个操作数");
                    double k = pop();
                    double n = pop();
                    if (n < 0 || k < 0 || n != std::floor(n) || k != std::floor(k)) {
                        throw std::runtime_error("错误: 杨辉三角输入必须为非负整数");
                    }
                    push(binomialCoefficient(static_cast<int>(n), static_cast<int>(k)));
                }
            }
            else {
                try {
                    // 尝试解析为double
                    size_t pos;
                    double value = std::stod(token, &pos);
                    
                    // 检查是否整个token都被解析了
                    if (pos != token.length()) {
                        throw std::invalid_argument("无效字符");
                    }
                    
                    push(value);
                }
                catch (const std::invalid_argument&) {
                    throw std::runtime_error("错误: 无效的输入 '" + token + "'");
                }
                catch (const std::out_of_range&) {
                    throw std::runtime_error("错误: 数值超出范围 '" + token + "'");
                }
            }
        }
    }

    double getResult() {
        if (stack.empty()) {
            throw std::runtime_error("错误: 栈为空");
        }
        return stack.back();
    }

    bool hasResult() const {
        return !stack.empty();
    }
};

int main() {
    RPNCalculator calc;
    std::string input;

    std::cout << "====================================" << std::endl;
    std::cout << "        C++ RPN 计算器" << std::endl;
    std::cout << "====================================" << std::endl;
    std::cout << "支持的操作: + - * / sqrt ^ fib pascal" << std::endl;
    std::cout << "特殊命令: clear, display, q/quit" << std::endl;
    std::cout << "====================================" << std::endl;
    
    while (true) {
        std::cout << "> ";
        std::getline(std::cin, input);

        // 去除前后空格
        input.erase(0, input.find_first_not_of(" \t"));
        input.erase(input.find_last_not_of(" \t") + 1);

        if (input == "q" || input == "quit") {
            std::cout << "感谢使用RPN计算器！" << std::endl;
            break;
        }
        else if (input.empty()) {
            continue;
        }
        else {
            try {
                calc.calculate(input);
                if (calc.hasResult()) {
                    double result = calc.getResult();
                    // 美化输出：如果是整数就显示整数形式
                    if (result == std::floor(result)) {
                        std::cout << "结果: " << static_cast<long long>(result) << std::endl;
                    } else {
                        std::cout << "结果: " << std::fixed << std::setprecision(6) << result << std::endl;
                        std::cout.unsetf(std::ios_base::floatfield); // 重置格式
                    }
                }
            }
            catch (const std::exception& e) {
                std::cout << e.what() << std::endl;
            }
        }
    }

    return 0;
}
