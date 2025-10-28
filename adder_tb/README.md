# Adder

此專案的 DUT 為一個可參數化的加法器，能將兩個輸入相加並輸出結果與進位位。  
整個驗證環境包含 Sequence、Driver、Monitor、Scoreboard、Agent、Environment、Test 等基本元件

---

## 一 專案目標

透過加法器這個簡單的 DUT 練習：
- 建立最小可運作的 UVM 環境
- 練習 virtual interface 的傳遞方式
- 建立 transaction 及 sequence item
- 建立 scoreboard 驗證結果正確性
- 熟悉 UVM phase 流程與物件互動

---

## 二 DUT 功能說明

DUT 為可參數化的加法器模組

```systemverilog
module adder #(parameter WIDTH = 8) (
  adder_if adderif
);
  assign {adderif.carry, adderif.sum} = adderif.a + adderif.b;
endmodule
````

主要輸入輸出

* a b 為兩個加數
* sum 為相加後的結果
* carry 為進位位元

---

## 三 Interface 定義

interface 負責連接 DUT 與 testbench，並定義 modport 方向

```systemverilog
interface adder_if #(parameter WIDTH=8);
  logic [WIDTH-1:0] a, b, sum;
  logic carry;
  modport drv_mp (output a, b, input sum, carry);
  modport mon_mp (input a, b, sum, carry);
endinterface
```

---

## 四 UVM 架構說明

整體結構如下

```
Sequence → Driver → DUT → Monitor → Scoreboard
```

### 1 Sequence Item

描述一次加法操作的 transaction
包含 a b sum carry 等欄位並可隨機化

### 2 Driver

從 sequencer 取得 transaction
透過 virtual interface 將 a b 傳入 DUT
再從 DUT 讀回 sum 與 carry

### 3 Monitor

被動觀察 DUT 的輸入輸出
在每次輸入變化時收集資料並送往 scoreboard

### 4 Scoreboard

比對期望值與實際輸出
當 {carry sum} 不等於 a + b 時回報錯誤

### 5 Agent

封裝 driver sequencer monitor
統一由 environment 管理

### 6 Environment

建立 agent 與 scoreboard 並連接分析端口

### 7 Test

建立 environment 並啟動 sequence
在 run_phase raise 與 drop objection 控制模擬時間

---

## 五 Top 測試平台

top 模組負責實例化 DUT 與 interface
並將 virtual interface 寫入 config_db 供 UVM 使用

```systemverilog
module top;
  adder_if adder_if1();
  adder dut (.adderif(adder_if1));

  initial begin
    uvm_config_db#(virtual adder_if)::set(null, "*", "vif", adder_if1);
    run_test("adder_test");
  end
endmodule
```

---

## 六 模擬流程

1. test 啟動 adder_sequence
2. sequence 建立多組隨機的 a b
3. driver 將資料送入 DUT
4. DUT 計算 sum 與 carry
5. monitor 觀察輸出並送到 scoreboard
6. scoreboard 驗證結果正確性並顯示 PASS 或 ERROR

---

## 七 預期模擬輸出

執行後會看到類似以下輸出

```
UVM_INFO [DRIVER] a=188 b=151 sum=83 carry=1
UVM_INFO [SCOREBOARD] PASS: a=188 b=151 sum=83 carry=1
UVM_INFO [SCOREBOARD] PASS: a=129 b=135 sum=8 carry=1
UVM_INFO [UVM/REPORT/SUMMARY] Simulation complete!
```
