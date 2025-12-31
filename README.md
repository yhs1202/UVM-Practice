# UVM-Practice

This repository contains a UVM-1.2 based verification environment for practicing and learning UVM concepts using Synopsys VCS and Verdi tools.

It also includes a comprehensive UVM Study Log, detailing the methodology's architecture and advanced concepts.

<details>
  <summary><strong>Project Setup & Makefile</strong></summary>

## Prerequisites
- Synopsys VCS simulator
- Synopsys Verdi for waveform viewing and debugging
- Basic knowledge of SystemVerilog and UVM concepts

## Directory Structure
- `rtl/`: Contains the DUT (Device Under Test) source files.

- `tb/`: Contains UVM environment files including agents, drivers, monitors, and sequences, as well as the top-level testbench.sv

- `clean.sh`: Script to clean up generated files from simulation and compilation.

- `run_verdi.sh`: Script to launch Verdi with the simulation results.

- `run.f`: File list for VCS compilation.

- `run.sh`: Script to compile and run the simulation using VCS.

- `Makefile`: Makefile for compiling and simulating the design and UVM environment.

<!-- - `uvm_env/`: Contains UVM environment files including agents, drivers, monitors, and sequences. -->
<!-- - `scripts/`: Simulation and compilation scripts. -->
<!-- - `docs/`: Documentation related to the verification environment. -->


## Getting Started
1. Clone this repository:
   ```bash
   git clone https://github.com/yhs1202/UVM-Practice.git
    cd UVM-Practice
    ```

2. Run Overall simulation and View waveforms in Verdi:
    ```bash
    make
    ```

3. or Run VCS build + simulation:
    ```bash
    make run
    ```

4. View waveforms in Verdi:
    ```bash
    make verdi
    ```

5. Clean up generated files:
    ```bash
    make clean
    ```

---

</details>


# UVM Study Log

This section contains a detailed study log of UVM concepts, architecture, and advanced topics. It serves as a reference for understanding UVM methodology and its application in verification environments.

# 0. Table of Contents
[**Part 1. UVM Introduction & Principle**](#part-1-uvm-introduction--principle)

- What is UVM?
- Why UVM is needed?
- Limitations of previous methodologies

[**Part 2. UVM Architecture & Hierarchy**](#part-2-uvm-architecture--hierarchy)

- UVM Class Hierarchy
- UVM Testbench Hierarchy

[**Part 3. Basic Mechanism**](#part-3-basic-mechanism)

- Factory
- Phasing
- Configuration Database (uvm_config_db)

[**Part 4. Sequence-based stimulus**](#part-4-sequence-based-stimulus)

- Sequence Item (Transaction)
- Lifetime of Sequence (Body, Pre/Post Start)
- Handshake between Sequencer and Driver (get_next_item, item_done)
- Virtual Sequence & Virtual Sequencer

[**Part 5. TLM (Transaction-Level Modeling)**](#part-5-tlm-transaction-level-modeling)

- Port, Export, Imp, Socket
- Blocking vs Non-blocking Communication
- Analysis Port and Observer Pattern

[**Part 6. RAL (Register Abstraction Layer)**](#part-6-ral-register-abstraction-layer)

- Necessity and Structure of RAL Model (Reg Block, Reg Map, Field)
- Frontdoor vs Backdoor Access
- Implicit Prediction vs Explicit Prediction


[**Part 7. Advanced Topics**](#part-8-advanced-topics)


# Part 1. UVM Introduction & Principle

## 1.1. What is UVM?
**UVM (Universal Verification Methodology)** 은 ASIC/FPGA 설계 검증을 위한 방법론 중 가장 표준화되고 강력한 SystemVerilog 기반의 Framework.

## 1.2. Why UVM is needed?
- 칩의 기능 복잡도가 증가하면서 RTL 설계의 오류를 시뮬레이션 단계에서 발견하지 못하면, Mask 재제작 및 re-spin 비용이 증가하고, 제품 출시 일정에도 치명적인 영향을 미침.

- 따라서 설계 품질을 확보하기 위해서는 **체계적**이고 **재사용 가능**하며 **유지보수가 용이**한 검증 방법론이 필요해짐.


## 1.3. Limitations of previous methodologies

- 구조적 일관성 및 재사용성 부족
    
    이전 방법론들은 프로젝트마다 Testbench 구조가 다르기 때문에 **재사용하기 어려움**. (검증 환경 구축 및 검증 IP 공유 어려움)
    
    또한, block-level에서 작성한 testbench를 sub-system-level이나 SoC-level로 가져가려면 대폭 수정이 필요함. (팀 간 협업이 어려움)
    
- 복잡한 검증 시나리오 처리에 대한 한계 및 가시성 부족

    Coverage 관리, Randomization, Assertion 기반 검증 등 **현대적인 검증 기법들을 효과적으로 지원하지 못함.**
    

- Verilog TB의 제약점
    1. Module base의 Static 구조들만 사용하여 구현되므로 test case를 재사용하거나 새로운 test 정의시에 신속성과 유동성이 부족함.

    2. Randomize된 test를 하기 위해서 constraint 등의 부가적인 mechanism을 추가하기 위한 작업들이 많이 필요함.

- SystemVerilog TB의 제약점

    1. Project 마다 전혀 다른 class들이 기술되어 **재사용성이 한정적**임.

    2. class의 효과적인 확장성과 재사용을 위해서 잘 설계된 base class 들이 필요하지만 이를 위한 초기 문턱이 높음. → **SV로 미리 class Template을 만들어 놓은 UVM 으로 발전**
        
        <!-- ![image.png]() -->
        
## 1.4. UVM Principles


# Part 2. UVM Architecture & Hierarchy

# Part 3. Basic Mechanism

# Part 4. Sequence-based stimulus

# Part 5. TLM (Transaction-Level Modeling)

# Part 6. RAL (Register Abstraction Layer)

# Part 7. Advanced Topics

# Part 8. Discussions

## 8.1. 왜 uvm_report_object를 상위 class로 만들어서 상속받게 했을까?
1. Verification 환경에서 기록을 남기는 것은 선택이 아닌 필수 사항.

    만약 상속을 받지 않고 Logger 같은 별도의 객체를 사용한다면 모든 Component를 만들 때마다 일일이 Logger 객체를 생성하고 연결해줘야함.
    
    따라서 UVM의 모든 Component는 logging 기능이 Built-in 되도록 만들어짐.

2. Hierarchical 한 Control을 위해서.

    UVM은 수많은 Component가 계층적으로 연결된 거대한 tree구조인데, 특정 부분에서의 로그는 불필요해서 끄고 싶을 때
    
    부모 Component의 reporting 설정을 바꾸면 그 하위의 자식 component에게 재귀적으로 영향을 줄 수 있는 구조를 쉽게 만들 수 있음.

이러한 이유로 report 기능을 최상위 근처에 두어 모든 UVM의 구성요소의 뼈대가 되도록 설계함.

## 8.2. \`uvm_do, \`uvm_do_with, \`uvm_do_on_with

### `uvm_do: sequence 또는 sequence_item 객체를 생성하고 Randomize 한 뒤, 현재 sequencer (m_sequencer) 에서 실행

``` `uvm_do``` 계열의 매크로를 사용하면 컴파일러는 아래와 같은 과정을 자동으로 코드로 확장함.

1. **Creation**
    
    `type_id::create()` 를 호출하여 factory로 객체 생성. (``` `uvm_do(req) ``` 에서 `req == null` 일 경우)
    
2. **Wait for grant**
    
    `start_item()` 을 호출하여 Driver가 준비될 때까지 대기.
    
    - `start_item()`은 “이 아이템을 보내고 싶다”를 sequencer에게 요청하고, sequencer arbitation 결과로 grant가 나올 때까지 블로킹 될 수 있음.
3. **Randomization**
    
    `randomize()` 를 호출 (`with` 가 있다면 constraint 적용)
    
4. **Execute**
    
    `finish_item()` 을 호출하여 Driver로 전송.
    
    `SEQ_OR_ITEM`: 실행할 객체
    
    `PRIORITY`: 우선순위 (default: -1)
    
    **Ref: UVM 1.2 Reference Implementation**
    ```verilog
    // UVM 1.2 
    `define uvm_do(SEQ_OR_ITEM) \
      `uvm_do_on_pri_with(SEQ_OR_ITEM, m_sequencer, -1, {})
      
      
    `define uvm_do_pri_with(SEQ_OR_ITEM, PRIORITY, CONSTRAINTS) \
    	`uvm_do_on_pri_with(SEQ_OR_ITEM, m_sequencer, PRIORITY, CONSTRAINTS)
    	
    // MACRO: `uvm_do_on_pri_with
    //
    //| `uvm_do_on_pri_with(SEQ_OR_ITEM, SEQR, PRIORITY, CONSTRAINTS)
    //
    // This is the same as `uvm_do_pri_with except that it also sets the parent
    // sequence to the sequence in which the macro is invoked, and it sets the
    // sequencer to the specified ~SEQR~ argument.
    
    `define uvm_do_on_pri_with(SEQ_OR_ITEM, SEQR, PRIORITY, CONSTRAINTS) \
      begin \
      uvm_sequence_base __seq; \
      `uvm_create_on(SEQ_OR_ITEM, SEQR) \
      if (!$cast(__seq,SEQ_OR_ITEM)) start_item(SEQ_OR_ITEM, PRIORITY);\
      if ((__seq == null || !__seq.do_not_randomize) && !SEQ_OR_ITEM.randomize() with CONSTRAINTS ) begin \
        `uvm_warning("RNDFLD", "Randomization failed in uvm_do_with action") \
      end\
      if (!$cast(__seq,SEQ_OR_ITEM)) finish_item(SEQ_OR_ITEM, PRIORITY); \
      else __seq.start(SEQR, this, PRIORITY, 0); \
      end
    ```
    **Note:**

    UVM 1.2 당시에는 SystemVerilog 매크로가 Default Argument를 제대로 지원하지 않아 기능별로 매크로를 따로 만들었지만, UVM IEEE 1800.2 부터는 ``uvm_do` 하나의 매크로로 통합해서 처리할 수 있게 되었음.
    
    ```verilog
    // @uvm-ieee 1800.2-2020 auto B.3.1.4
    `define uvm_do(SEQ_OR_ITEM, SEQR=get_sequencer(), PRIORITY=-1, CONSTRAINTS={}) \
      begin \
      `uvm_create(SEQ_OR_ITEM, SEQR) \
      `uvm_rand_send(SEQ_OR_ITEM, PRIORITY, CONSTRAINTS) \
      end
    ```
    
5. ``` `uvm_do_with ```: ``` `uvm_do ``` + Constraints 기능 추가
    - 특정 테스트 시나리오를 위해 랜덤 변수의 값을 고정하거나 범위를 제한할 때 사용.
    - 중괄호로 묶어서 Constraints 설정.
    
    ```verilog
    // MACRO: `uvm_do_with
    //
    //| `uvm_do_with(SEQ_OR_ITEM, CONSTRAINTS)
    //
    // This is the same as `uvm_do except that the constraint block in the 2nd
    // argument is applied to the item or sequence in a randomize with statement
    // before execution.
    
    `define uvm_do_with(SEQ_OR_ITEM, CONSTRAINTS) \
      `uvm_do_on_pri_with(SEQ_OR_ITEM, m_sequencer, -1, CONSTRAINTS)
    ```
    
6. ``` `uvm_do_on_with ```: ``` `uvm_do_with ``` +  객체를 실행할 특정 Sequencer를 명시적으로 지정.
    - 기존에는 `get_sequencer()` 를 통해 m_sequencer 에서 실행했지만 ``` `uvm_do_on_with ``` 에서는 target Sequencer를 명시적으로 지정하여 동작시킴.
    - 주로 Virtual Sequence 에서 사용됨. Virtual Sequence는 자체적인 물리적 인터페이스가 없으므로, 하위 Agent의 Sequencer를 지정하여 동작을 시켜야 하기 때문임.

# Reference

SystemVerilog (IEEE 1800-2017) LRM: https://ieeexplore.ieee.org/document/8299595

VLSI Verify UVM: https://vlsiverify.com/uvm/

Chipverify UVM: https://www.chipverify.com/uvm/

Verification Guide UVM: https://verificationguide.com/uvm/uvm-tutorial/

Siemens Verification Academy UVM Cookbook: https://verificationacademy.com/topics/uvm-universal-verification-methodology/

UVM IEEE 1800.2 Reference Implementation: https://github.com/accellera-official/uvm-core

UVM IEEE 1800.2-2020 LRM: https://ieeexplore.ieee.org/document/9195920

UVM 1.2 Reference Implementation: https://github.com/gchinna/uvm-1.2
