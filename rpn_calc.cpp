#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <cmath>
#include <stack>
#include <map>
#include <functional>
#include <stdexcept>
#include <iomanip>

class RPNCalculator {
private:
    std::stack<double> stack;
    std::map<std::string, std::function<void()>> operations;
    
    void setupOperations() {
        // 基本四则运算
        operations["+"] = [this]() { binaryOp([](double a, double b) { return a + b; }); };
        operations["-"] = [this]() { binaryOp([](double a, double b) { return a - b; }); };
        operations["*"] = [this]() { binaryOp([](double a, double b) { return a * b; }); };
        operations["/"] = [this]() { 
            if (stack.top() == 0) throw std::runtime_error("除零");
            binaryOp([](double a, double b) { return a / b; });
        };
        
        // 高级数学运算
        operations["sqrt"] = [this]() { 
            unaryOp([](double a) { 
                if (a < 0) throw std::runtime_error("平方根错误：不能对负数开平方");
                return std::sqrt(a); 
            });
        };
        operations["^"] = [this]() { binaryOp([](double a, double b) { return std::pow(a, b); }); };
        
        // 斐波那契数列
        operations["fib"] = [this]() {
            checkStackSize(1);
            int n = static_cast<int>(stack.top());
            if (n < 0) throw std::runtime_error("斐波那契错误：需要非负整数参数");
            stack.pop();
            stack.push(fibonacci(n));
        };
        
        // 杨辉三角（返回第n行第k列的值）
        operations["pascal"] = [this]() {
            checkStackSize(2);
            int k = static_cast<int>(stack.top()); stack.pop();
            int n = static_cast<int>(stack.top()); stack.pop();
            if (n < 0 || k < 0 || k > n) throw std::runtime_error("杨辉三角参数错误");
            stack.push(pascal(n, k));
        };
    }
    
    void binaryOp(std::function<double(double, double)> op) {
        checkStackSize(2);
        double b = stack.top(); stack.pop();
        double a = stack.top(); stack.pop();
        stack.push(op(a, b));
    }
    
    void unaryOp(std::function<double(double)> op) {
        checkStackSize(1);
        double a = stack.top(); stack.pop();
        stack.push(op(a));
    }
    
    void checkStackSize(int required) {
        if (stack.size() < required) {
            throw std::runtime_error("栈不足");
        }
    }
    
    long long fibonacci(int n) {
        if (n == 0) return 0;
        if (n == 1) return 1;
        
        long long a = 0, b = 1;
        for (int i = 2; i <= n; i++) {
            long long temp = a + b;
            a = b;
            b = temp;
        }
        return b;
    }
    
    long long pascal(int n, int k) {
        if (k == 0 || k == n) return 1;
        
        // 使用组合数公式 C(n, k) = n! / (k! * (n-k)!)
        long long result = 1;
        if (k > n - k) k = n - k; // 利用对称性
        
        for (int i = 0; i < k; i++) {
            result = result * (n - i) / (i + 1);
        }
        return result;
    }

public:
    RPNCalculator() {
        setupOperations();
    }
    
    void processInput(const std::string& input) {
        std::istringstream iss(input);
        std::string token;
        
        while (iss >> token) {
            if (operations.find(token) != operations.end()) {
                // 是操作符
                try {
                    operations[token]();
                    std::cout << "结果: " << stack.top() << std::endl;
                } catch (const std::exception& e) {
                    std::cout << "错误: " << e.what() << std::endl;
                }
            } else if (token == "display") {
                // 显示栈内容
                displayStack();
            } else if (token == "clear") {
                // 清空栈
                while (!stack.empty()) stack.pop();
                std::cout << "栈已清空" << std::endl;
            } else if (token == "help") {
                // 显示帮助
                showHelp();
            } else if (token == "q" || token == "quit") {
                // 退出程序
                std::cout << "再见!" << std::endl;
                exit(0);
            } else {
                // 尝试解析为数字
                try {
                    double value = std::stod(token);
                    stack.push(value);
                } catch (const std::exception&) {
                    std::cout << "错误: 无效数字" << std::endl;
                    return;
                }
            }
        }
    }
    
    void displayStack() {
        if (stack.empty()) {
            std::cout << "当前栈：空" << std::endl;
            return;
        }
        
        std::stack<double> temp = stack;
        std::vector<double> elements;
        
        while (!temp.empty()) {
            elements.push_back(temp.top());
            temp.pop();
        }
        
        std::cout << "当前栈：";
        for (auto it = elements.rbegin(); it != elements.rend(); ++it) {
            std::cout << *it << " ";
        }
        std::cout << std::endl;
    }
    
    void showHelp() {
        std::cout << "================= RPN 计算器帮助 =================" << std::endl;
        std::cout << "支持操作符：+（加）、-（减）、*（乘）、/（除）、sqrt（平方根）、^（幂运算）、fib（斐波那契）、pascal（杨辉三角）" << std::endl;
        std::cout << "特殊命令：clear（清空栈）、display（显示栈）、help（查看帮助）、q/quit（退出）" << std::endl;
        std::cout << "输入规则：操作数与运算符用空格分隔，按回车计算" << std::endl;
        std::cout << "================================================" << std::endl;
    }
};

int main() {
    RPNCalculator calculator;
    std::string input;
    
    std::cout << "RPN Calculator > ";
    
    while (std::getline(std::cin, input)) {
        if (!input.empty()) {
            calculator.processInput(input);
        }
        std::cout << "RPN Calculator > ";
    }
    
    return 0;
}
