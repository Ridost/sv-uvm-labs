## Quick start with EDA Playground
https://edaplayground.com/x/bdRv

## Introduction
練習使用Objection機制，控制Task Phase的執行和終止
 - 必須要在耗時命令之前呼叫raise_objection
 - 在結束phase之前要呼叫drop_objection，否則有可能無法退出該phase
 - raise和drop的動作會影響到不同component當中同名的task phase (例如: driver reset_phase呼叫raise_objection會影響到monitor的reset_phase)

   
