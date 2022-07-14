/************
파일명 : Or15PLSQL.sql
PL/SQL
설명 : 오라클에서 제공하는 프로그래밍 언어
*************/
/*
PL/SQL(Procedural Language)
    : 일반 프로그래밍 언어에서 가지고 있는 요소를 모두 가지고 있으며 DB업무를
    처리하기 위해 최적화된 언어이다
*/
--HR계정에서 실습합니다. 

--화면상에 내용을 출력하고 싶을때 on으로 설정한다. off일때는 출력되지 않는다. 
set serveroutput on;
declare --선언부 : 주로 변수를 선언한다. 
    cnt number; --숫자타입의 변수 선언
begin --실행부 : begin~end절 사이에 실행을 위한 로직을 기술한다. 
    cnt := 10; --변수에 10을 할당한다. 대입연산자는 := 을 사용한다. 
    cnt := cnt + 1;
    dbms_output.put_line(cnt);--java의 println()과 동일하다. 
end;
/
/*
    PL/SQL 문장의 끝에는 반드시 /를 붙여야 하는데, 만약 
    없으면 호스트환경으로 빠져나오지 못한다. 즉 PL/SQL문장을 
    탈출하기위해 필요하다. 
    호스트환경이란 쿼리문을 입력하기 위한 SQL> 상태를 말한다. 
*/

/*
시나리오] 사원테이블에서 사원번호가 120인 사원의 이름과 연락처를 출력하는
    PL/SQL문을 작성하시오.
*/
select concat(first_name||' ', last_name), phone_number
from employees where employee_id=120;

declare
    /*
    선언부에서 변수를 선언할때는 테이블 생성시와 동일하게 선언한다. 
    => 변수명 자료형(크기)
    단, 기존에 생성된 컬럼의 타입과 크기를 참조하여 선언해주는것이 좋다. 
    아래 이름의 경우 두개의 컬럼이 합쳐진 상태이므로 조금 더 넉넉한 크기로 
    설정해주는것이 좋다. 
    */
    empName varchar2(50);
    empPhone varchar2(20);
begin
    /*
    실행부 : select절에서 가져온 결과를 선언부에서 선언한 변수에 1:1로
        대입하여 값을 저장한다. 이때 into를 사용한다. 
    */
    select concat(first_name||' ', last_name), phone_number
        into empName, empPhone
    from employees where employee_id=120;
    
    dbms_output.put_line(empName||' '||empPhone);
end;
/

/*
시나리오] 부서번호 10인 사원의 사원번호, 급여, 부서번호를 가져와서 
    아래 변수에 대입후 화면상에 출력하는 PL/SQL문을 작성하시오. 
    단, 변수는 기존테이블의 자료형을 참조하는 '참조변수'로 선언하시오.

    참조변수 : 특정 테이블의 특정 컬럼을 참조하는 변수로써 
        동일한 자료형과 크기로 선언하고 싶을때 사용한다. 
        형식] 테이블명.컬럼명%type
            => 테이블의 '하나'의 컬럼만을 참조한다.
*/
--시나리오의 조건에 맞는 select문을 작성한다.
select employee_id, salary, department_id
from employees where department_id=10;

declare
    --사원테이블의 특정 컬럼의 타입과 크기를 그대로 참조하는 참조변수로 선언한다. 
    eid employees.employee_id%type; --number(6)
    sal employees.salary%type; --number(8,2)
    deptid employees.department_id%type;--number(4)와 동일하다. 
begin
    --select의 결과는 into를 통해 선언한 변수에 할당한다. 
    select employee_id, salary, department_id
        into eid, sal, deptid
    from employees where department_id=10;
    
    dbms_output.put_line(eid||' '||sal||' '||deptid);
end;
/

/*
시나리오] 사원번호가 100인 사원의 레코드를 가져와서 emp_row변수에 전체컬럼을
저장한 후 화면에 다음 정보를 출력하시오.
단, emp_row는 사원테이블이 전체컬럼을 저장할 수 있는 참조변수로 선언해야한다.
출력정보 : 사원번호, 이름, 이메일, 급여
*/
declare
    /*
    전체컬럼을 참조하는 참조변수 : 테이블명 뒤에 %rowtype을 붙여서
        선언한다. 
    */
    emp_row employees%rowtype;
begin
    /*
    와일드카드 *를 통해 얻어온 전체컬럼을 변수 emp_row에 한꺼번에 저장한다. 
    */
    select * into emp_row
    from employees where employee_id=100;
    /*
    emp_row에는 전체컬럼의 정보가 저장되므로 출력시에는 변수명.컬럼명
    형태로 기술해야 한다. 
    */
    dbms_output.put_line(emp_row.employee_id||' '||
                        emp_row.first_name||' '||
                        emp_row.email||' '||
                        emp_row.salary);
end;
/



/*
복합변수
    : class를 정의하듯 필요한 자료형을 묶어서 생성하는 변수
    
    아래는 2개의 자료형을 가진 복합변수를 생성하고 있다. 
    특정 컬럼을 그대로 사용할때는 참조변수 %type형태로 선언하고
    컬럼을 합치거나 변경해야 할 경우 임의생성도 가능하다. 
    형식]
        type 복합변수자료형 is record(
            컬럼명1 자료형1,
            컬럼명2 참조변수%type ....
        );
*/
/*
시나리오] 사원번호, 이름(first_name+last_name), 담당업무명을 저장할 수 있는 
복합변수를 선언한 후, 100번 사원의 정보를 출력하는 PL/SQL을 작성하시오.
*/
--쿼리문작성
select employee_id, first_name||' '||last_name, job_id
from employees where employee_id=100;

declare
    --3개의 값을 저장할 수 있는 복합자료형을 선언한다. 
    type emp_3type is record(
        emp_id employees.employee_id%type, /*기존 컬럼을 참조하는 참조변수 */
        emp_name varchar2(50), /* 새롭게 생성한 변수 */
        emp_job employees.job_id%type
    );
    --앞에서 선언한 복합자료형을 통해 선언한 복합변수. 3개의 컬럼을 저장할수 있다. 
    record3 emp_3type;
begin
    select employee_id, first_name||' '||last_name, job_id 
        into record3
    from employees where employee_id=100;
    
    dbms_output.put_line(record3.emp_id||' '||
                        record3.emp_name||' '||
                        record3.emp_job);
end;
/
-----------------------------------------------------------
/*
연습문제]아래 절차에 따라 PL/SQL문을 작성하시오.
1.복합변수생성
- 참조테이블 : employees
- 복합변수자료형의 이름 : empTypes
        멤버1 : emp_id -> 사원번호
        멤버2 : emp_name -> 사원의전체이름(이름+성)
        멤버3 : emp_salary -> 급여
        멤버4 : emp_percent -> 보너스율
위에서 생성한 자료형을 이용하여 복합변수 rec2를 생성후 사원번호 100번의 정보를 할당한다.
2.1의 내용을 출력한다.
3.위 내용을 완료한후 치환연산자를 사용하여 사원번호를 사용자로부터 입력받은 후 
해당 사원의 정보를 출력할수있도록 수정하시오.[보류
]
*/
--문제의 조건에 맞는 select 쿼리문 작성
 select 
     employee_id, first_name||' '||last_name , salary, nvl(COMMISSION_PCT,0)
         into rec2
from employees where employee_id=100;

--출력결과를 화면상에 표시하기 위한 명령으로 첫 실행시 반드시 필요함.
set serveroutput on;

declare
    --4개의 멤버를 가진 복합변수자료형 선언
    type empType is record(
        emp_id employees.employee_id%type,
        emp_name VARCHAR2(50),
        emp_salary employees.salary%type,
        emp_percent employees.COMMISSION_PCT%type
    );
    --복합변수자료형을 통해 변수 생성
    rec2 empType;

begin
    select 
        employee_id, first_name||' '||last_name , salary, nvl(COMMISSION_PCT,0)
            into rec2
    from employees where employee_id=100;
    dbms_output.put_line('사원번호/ 사원명/ 급여/ 보너스율');
    dbms_output.put_line(rec2.emp_id||' '||
                         rec2.emp_name||' '||
                         rec2.emp_salary||' '||
                         rec2.emp_percent);
end;
/

/*
치환연산자 : PL/SQL에서 사용자로부터 데이터를 입력받을때 사용하는 연산자로
변수앞에 &을 붙여주면 된다. 실행시 입력창이 뜬다.
*/
--앞에서 작성했던 PL/SQL을 3번에서 요구한 치환연산자로 사원번호를 입력받아 처리한다.
--퀴즈의 정답을 그대로 복사한 후 수정한다.
declare
    --4개의 멤버를 가진 복합변수자료형 선언
    type empType is record(
        emp_id employees.employee_id%type,
        emp_name VARCHAR2(50),
        emp_salary employees.salary%type,
        emp_percent employees.COMMISSION_PCT%type
    );
    --복합변수자료형을 통해 변수 생성
    rec2 empType;
    --치환연산자를 통해 입력받은 값을 할당받는 변수
    inputNum number(3) := &inputNum;
begin
    select 
        employee_id, first_name||' '||last_name , salary, nvl(COMMISSION_PCT,0)
            into rec2
    from employees where employee_id= inputNum;/*사원번호를 변수로 대체한다.*/
    dbms_output.put_line('사원번호/ 사원명/ 급여/ 보너스율');
    dbms_output.put_line(rec2.emp_id||' '||
                         rec2.emp_name||' '||
                         rec2.emp_salary||' '||
                         rec2.emp_percent);
end;
/

/*
바인드변수
    : 호스트환겨에서 선언된 변수로써 비 PL/SQL변수이다.
    호스트환경이란 PL/SQL의 블럭을 제외한 나머지 부분을 말한다.
    콘솔(CMD)에서는 SQL> 명령프롬프트가 있는 상태를 말한다.
    
    형식] 
        var 변수명 자료형;
        혹은
        variable 변수명 자료형;
*/
set serveroutput on;
--호스트환경에서 바인드변수 선언
var return_var number;
--PL/SQl작성
declare 
    --선언부에는 이와같이 아무내용이 없을수도 있다.
begin 
    /*
    일반변수와의 구분을 위해 바인드변수 앞에서 :(콜론)을 추가해야한다.
    */
    :return_var := 999;
    dbms_output.put_line(:return_var);
end;
/

print return_var;
/*
    호스트환경에서 출력할때는 print문을 사용한다.
    출력이 제대로 안되면 CMD창에서 확인해보면 정상적으로 출력된ㄷ나.
*/

---------------------------------------------------------------
--제어문(조건문) : if문, case문과 같은 조건문을 학습

--if문 : 홀수와 짝수를 판단하는 if문

--시나리오] 변수에 저장된 숫자가 홀수 or 짝수인지 판단하는 PL/SQL을 작성하시오.

declare
    --선언부에서 숫자타입의 변수 선언
    num number;
begin
    num := 10;
    --mod(변수, 정수) : 변수를 정수로 나눈 나머지를 반환하는 함수
    if mod(num,2) = 0 then
        dbms_output.put_line(num ||'은 짝수');
    else
        dbms_output.put_line(num ||'은 홀수');
    end if;
end;
/

--위 예제를 치환연산자를 통해 숫자를 입력받은 후 판단할 수 있도록 수정하시오.
declare
    --치환연산자는 선언부에 사용할 수 있다.
    num number := &num;
begin
    --num := 10; --선언부에서 치환연산자를 통해 입력받으므로 할당 필요없음

    if mod(num,2) = 0 then
        dbms_output.put_line(num ||'은 짝수');
    else
        dbms_output.put_line(num ||'은 홀수');
    end if;
end;
/
/*
시나리오] 사원번호를 사용자로부터 입력받은 후 해당 사원이 어떤부서에서
근무하는지를 출력하는 PL/SQL문을 작성하시오. 단, if~elsif문을 사용하여
구현하시오.
*/
declare
    --치환연산자를 통해 사원번호를 입력받음
    emp_id employees.employee_id%type := &emp_id;
    emp_name varchar2(50);
    emp_dept employees.department_id%type;
    --부서명은 선언과 동시에 초기화한다. 일치하는 정보가 없는경우 초깃값으로 출력한다.
    dept_name varchar2(30) := '부서정보없음';
begin
    select employee_id, last_name, department_id
        into emp_id, emp_name, emp_dept
    from employees
    where employee_id = emp_id;--입력받은 사원번호를 쿼리에 적용한다.
    
    /*
    여러개의 조건을 사용할 경우 java와 같이 else if를 사용하는것이 아니라
    elsif로 기술해야 한다. 또한 중괄호 대신 then과 end if; 가 사용된다.
    */
    if emp_dept = 50 then
        dept_name := 'Shipping';
    elsif emp_dept = 60 then
        dept_name := 'IT';
    elsif emp_dept = 70 then
        dept_name := 'Public Relations';
    elsif emp_dept = 80 then
        dept_name := 'Sales';
    elsif emp_dept = 90 then
        dept_name := 'Executive';
    elsif emp_dept = 100 then
        dept_name := 'Finance';
    end if;
    
    dbms_output.put_line('사원번호'|| emp_id ||'의정보');
    dbms_output.put_line('이름:'|| emp_name
            ||', 부서번호:'|| emp_dept
            ||', 부서명:'|| dept_name );
end;
/

/*
시나리오] 앞에서 if~elsif로 작성한 PL/SQL문을 case~when문으로 변경하시오.
*/
declare
    emp_id employees.employee_id%type := &emp_id;
    emp_name varchar2(50);
    emp_dept employees.department_id%type;
    dept_name varchar2(30) := '부서정보없음';
begin
    select employee_id, last_name, department_id
        into emp_id, emp_name, emp_dept
    from employees
    where employee_id = emp_id;
    
    /*
    case~when문이 if문과 다른점은 할당할 변수를 먼저 선언한 후 문장내에서
    조건을 판단하여 하나의 값을 할당하는 방식이다. 따라서 변수를 중복으로
    기술하지 않아도 된다.
    */
    dept_name := 
        case emp_dept
            when 50 then 'Shipping'
            when 60 then 'IT'
            when 70 then 'Public Relations'
            when 80 then 'Sales'
            when 90 then 'Executive'
            when 100 then 'Finance'
        end;
    
    dbms_output.put_line('사원번호'|| emp_id ||'의정보');
    dbms_output.put_line('이름:'|| emp_name
            ||', 부서번호:'|| emp_dept
            ||', 부서명:'|| dept_name );
end;
/

/*
case문 : java의 switch문과 비슷한 조건문
형식]
    case 변수
        when 값1 then '할당값1'
        when 값2 then '할당값2'
        ....값N
    end;
*/

-----------------------------------------------
--제어문(반복문)
/*
반복문1 : Basic loop문
    Java의 do~while문과 같이 조건체크없이 일단 loop로 진입한 후 탈출조건이
    될때까지 반복한다. 탈출시에는 exit를 사용한다.
*/


declare
    num number := 0;
begin
    loop
        --0~10까지 출력한다.
        dbms_output.put_line(num);
        num := num +1;
        --num이 10을 초과하면 loop문을 탈출한다.
        exit when (num>10); --exit는 Java의 break와 동일한 역활
    end loop;
end;
/
/*
시나리오] Basic loop문으로 1부터 10까지의 정수의 합을 구하는 
    프로그램을 작성하시오.
*/
declare
    i number := 1; --증가시킬 변수
    sumNum number := 0; --누적할 변수
    --변수명으로 sum을 사용할수 없다. 예약어(그룹함수)이므로 오류가 발생한다.
begin
    /*
    PL/SQL에서는 복합대입연산자, 증감연산자가 없으므로 누적합 혹은 변수의 증감은
    아래와 같이 구현한다.
    */
    loop
        --증가하는 변수i를 누적해서 더한다.
        sumNum := sumNum +i;
        --변수i는 1씩 증가한다.
        i := i + 1;
        exit when (i>10);
    end loop;
    dbms_output.put_line('1~10까지의합은:'|| sumNum);
end;
/

/*
반복문2 : whole문
    Basic loop 와는 다르게 조건을 먼저 확인한 후 실행한다.
    즉, 조건에 맞지 않는다면 한번도 실행되지 않을수 있다.
*/
declare
    num1 number := 0;
begin
    --while문 진입전 조건을 먼저 확인한다.
    while num1<11 loop
        --0~10까지 출력한다.
        dbms_output.put_line('이번숫자는:'|| num1);
        num1 := num1 + 1;
    end loop;
end;
/

/*
시나리오] while loop문으로 다음과 같은 결과를 출력하시오.
*
**
***
****
*****
*/
declare
    -- *를 누적해서 연결할 문자형 변수 선언
    starStr varchar2(100);
    -- 반복을 위한 변수 선언 및 초기화
    i number := 1;
    j number := 1;
begin
    while i <= 5 loop
        while j <= 5 loop
            starStr := starStr || '*';
            --조건이 false일때 가장 가까운 while문을 탈출
            exit when (j<=i);
         j := j+1;
        end loop;
        dbms_output.put_line(starStr);
        i := i + 1;
        j := 1;--j를 1로 다시 초기화
    end loop;
end;
/

/*
시나리오] while loop문으로 1부터 10까지의 정수의 합을 구하는 프로그램을 작성하시오. 
*/
declare
    i number := 1;
    sumNum number := 0;
begin
    while i<=10 loop
        sumNum := sumNum + i;
        i := i + 1;
    end loop;
    dbms_output.put_line('1~10까지의합은:'|| sumNum);
end;
/

/*
반복문3 : for문
    반복의 횟수를 지정하여 사용할 수 있는 반복문으로, 반복을 위한 변수를
    별도로 선언하지 않아도 된다. 그러므로 특별한 이유가 없다면 선언부(declare)를
    기술하지 않아도 된다.
*/
declare
begin
    for num2 in 0 .. 10 loop
        dbms_output.put_line('for문짱인듯:'|| Num2);
    end loop;
end;
/

begin
    for num3 in reverse 0 .. 10 loop
        dbms_output.put_line('거꾸로for문짱인듯:'|| Num3);
    end loop;
end;
/

/*
연습문제] for loop문으로 구구단을 출력하는 프로그램을 작성하시오. 
*/

--줄바꿈 되는 버전
begin
    --단은 2~9까지
    for dan in 2 .. 9 loop
        dbms_output.put_line(dan||'단');
        --수는 1~9까지 
        for su in 1 .. 9 loop
            --구구단을 즉시 출력하고 줄바꿈처리
            dbms_output.put_line(dan||'*'||su||'='||(dan*su));
        end loop;
    end loop;
end;
/

--줄바꿈 없는 버전
declare
    --구구단에서 하나의 단을 저장하기 위한 변수
    guguStr varchar2(1000);
begin
    --단에 해당하는 loop
    for dan in 2 .. 9 loop
        --수에 해당하는 loop
        for su in 1 .. 9 loop
            --하나의 단을 문자형변수에 누적해서 연결한다.
            guguStr := guguStr || dan ||'*'|| su ||'='|| (dan*su) ||' ';
        end loop;
        --하나의 단의 누적이 완료되면 출력한다.
        dbms_output.put_line(guguStr);
        --그 다음 단을 저장하기 위해 초기화한다.
        guguStr := '';
    end loop;
end;
/


/*
커서(Curosr)
    : select 문장에 의해 여러행이 반환되는 경우 각 행에 접근하기 위한 개체
    선언방법]
        Cursor 커서명 Is
            Select 쿼리문. 단 into절이 없는 형태로 기술한다.
        
    Open Cursor
        : 쿼리를 수행하라는 의미. 즉 Open할때 Cursor선언시의 select문장이 실행되어
        결과셋을 얻게된다. Cursor는 그 결과셋의 첫번째행에 위치하게 된다.
    Fetch~Into~
        :결과셋에서 하나의 행을 읽어들이는 작업으로 결과셋의 인출(Fetch)후에
        Cursor는 다음행으로 이동한다.
    Close Cursor
        : 커서 닫기로 결과셋의 자원을 반납한다. select문장이 모두 처리된 후 Cursor를
        닫아준다.
    Cursor의 속성
        %Found : 가장 최근의 인출(Fetch)이 행을 Return 하면 True, 아니면
            False를 반환한다.
        %RowCount : 지금까지 Return된 행의 갯수를 반환한다.
*/

/*
시나리오] 부서테이블의 레코드를 Cursor를 통해 출력하는 PL/SQL문을 작성하시오.
*/
declare
    --부서테이블의 전체 컬럼을 참조하는 참조변수 선언
    v_dept departments%rowtype;
    --커서선언 : 부서테이블의 모든 레코드를 조회하는 select 쿼리문 작성
    --          into절이 없다.
    cursor cur1 is
        select 
            department_id, department_name, location_id
        from departments;
begin
    /*
    해당 쿼리문을 수행해서 결과셋(ResultSet)을 가져온다. 결과셋이란
    쿼리(질의)문을 수행한 후 반환되는 레코드의 결과를 말한다.
    */
    open cur1;
    --basic루프문으로 얻어온 결과셋의 갯수만큼 반복하여 인출한다.
    loop
        --각 컬럼의 값을 참조변수에 저장한다.
        fetch cur1 into
            v_dept.department_id,
            v_dept.department_name,
            v_dept.location_id;
        --탈출조건으로 더 이상 인출할 행이 없으면 exit가 실행된다.
        exit when cur1%notfound;
        
        dbms_output.put_line(v_dept.department_id||' '||
                        v_dept.department_name||' '||
                        v_dept.location_id);
    
    end loop;
    --커서의 자원반납
    close cur1;
end;
/

/*
시나리오] Cursor를 사용하여 사원테이블에서 커미션이 null이 아닌 
사원의 사원번호, 이름, 급여를 출력하시오. 
출력시에는 이름의 오름차순으로 정렬하시오.
*/
--문제의 조건에 맞는 쿼리문 작성
select * from employees where commission_pct is not null;

declare
    --작성한 쿼리를 통해 커서를 생성한다.
    cursor curEmp is
        select employee_id, last_name, salary
        from employees
        where commission_pct is not null
        order by last_name asc;
    --사원테이블의 전체컬럼을 참조하는 참조변수 선언
    varEmp employees%rowType;
begin
    --커서를 오픈하여 쿼리문을 실행한다.
    open curEmp;
    --Basic loop문을 통해 커서에 저장된 결과셋을 인출한다.
    loop
        fetch curEmp
            into varEmp.employee_id, varEmp.last_name, varEmp.salary;
        --인출할 결과셋이 없으면 loop문을 탈출한다.
        exit when curEmp%notFound;
        dbms_output.put_line(varEmp.employee_id ||' '||
                                varEmp.last_name||' '||
                                varEmp.salary);
    end loop;
    --커서를 닫아준다.
    close curEmp;
end;
/
select * from employees where last_name='Abel';


/*
컬렉션(배열)
    : 일반 프로그래밍 언어에서 사용하는 배열타입을 PL/SQL에서는 테이블 타입이라고 한다.
    1차원, 2차원 배열을 생각해보면 테이블(표)와 같은 형태이기 때문이다.
종류
    -연관배열
    -VArray
    -중첩테이블

1.연관배열(Associative Array)
    : 키와 값 한쌍으로 구성된 컬렉션으로 Java의 해시맵과 같은 개념이다.
    Key : 자료형은 주로 숫자를 사용하며 binary_integer, pls_integer가 주로 사용된다.
        이 두가지 타입은 number보다 크기는 작고, 산술연산에 빠른 특징을 가진다.
    value : 자료형은 문자형이며 주로 varchar2가 사용된다
    
    형식] Type 연관배열자료형 Is
            Table of 연관배열 값 타입
            Index by 연관배열 키 타입
*/


/*
시나리오] 다음의 조건에 맞는 연관배열을 생성한 후 값을 할당하시오.
    연관배열 자료형 명 : avType, 값의자료형:문자형, 키의자료형:문자형
    key : girl, boy
    value : 트와이스, 방탄소년단
    변수명 : var_array
*/
declare
    --연관배열 자료형 생성
    Type avType Is
        Table Of varchar2(30) --value(값)의 자료형 선언
        Index By varchar2(10); --key(키, 인덱스)의 자료형 선언
    --연관배열 타입의 변수선언
    var_array avType;
begin
    --연괍내열에 값 할당
    var_array('girl') := '트와이스';
    var_array('boy') := '방탄소년단';
    --출력
    dbms_output.put_line(var_array('girl'));
    dbms_output.put_line(var_array('boy'));
end;
/

/*
시나리오] 100번 부서에 근무하는 사원의 이름을 저장하는 연관배열을 생성하시오.     
key는 숫자, value는 full_name 으로 지정하시오.
*/
--100번부서에 근무하는 직원 출력
select * from employees where department_id=100;--6개
--Full name을 출력하기 위한 쿼리문 작성
select first_name||' '||last_name
    from employees where department_id=100;
--문제의 조건을 통한 쿼리에서 다수행이 인출되었으므로 Cursor를 사용해야한다.
declare
    --쿼리문을 통해 커서 생성
    cursor emp_cur is 
        select first_name||' '||last_name from employees
        where department_id=100;
    --연관배열 자료형 생성(key:숫자형, value:문자형)    
    Type nameAvType Is
        Table Of varchar2(30)
        Index By binary_integer;
    --자료형을 기반으로 변수 생성
    names_arr nameAvType;
    --사원의 이름과 인덱스로 사용할 변수 생성
    fname varchar2(50);
    idx number := 1;
begin
    /*
    커서를 오픈하여 쿼리문을 실행한 후 얻어온 결과셋의 갯수만큼 반복하여 
    사원명을 인출한다.
    */
    open emp_cur;
    loop
        fetch emp_cur into fname;
        exit when emp_cur%NotFound;
        --연관배열 변수에 사원이름을 입력한다.
        names_arr(idx) := fname;
        --키로 사용될 인덱스 증가
        idx := idx +1;
    end loop;
    close emp_cur;
    
    /*
    연관배열.count : 연관배열에 저장된 갯수 반환
    */
    for i in 1 .. names_arr.count loop
        dbms_output.put_line(names_arr(i));
    end loop;
end;
/

/*
2.VArray(Variable Array)
    : 고정길이를 가진 배열로써 일반 프로그래밍 언어에서 사용하는 배열과 동일하다.
    크기에 제한이 있어서 선언할때 크기(원소의갯수)를 지정하면 이보다 큰 배열로
    만들 수 없다.
    형식] Type 배열타입명 Is
                Array(배열크기) Of 원소값의타입;
*/
declare
    --VArray타입 선언 : 크기는 5, 저장할 데이터는 문자형으로 지정한다.
    type vaType is
        array(5) of varchar2(20);
    --VArray형 배열변수 선언
    v_arr vaType;
    cnt number := 0;
begin
    --생성자를 통한 값의 초기화(총 5개중 3개만 할당한다.)
    v_arr := vaType('First','Second','Third','','');
    
    --Basic loop문을 통해 배열의 원소를 출력한다.(※인덱스는 1부터 시작함)
    loop
        cnt := cnt + 1;
        --탈출조건은 when대신 if를 사용할수도 있다.
        if cnt>5 then
            exit;
        end if;
        --배열처럼 인덱스를 통해 출력한다.
        dbms_output.put_line(v_arr(cnt));
    end loop;
    
    --배열의 원소 재할당
    v_arr(3) := '우리는';
    v_arr(4) := 'JAVA';
    v_arr(5) := '개발자다';
    --for문으로 출력
    for i in 1 .. 5 loop
        dbms_output.put_line(v_arr(i));
    end loop;
end;
/

/*
시나리오] 100번 부서에 근무하는 사원의 이름을 인출하여 VArray에 저장한 후
    출력하는 PL/SQL을 작성하시오.
*/
select * from employees where department_id=100;--6개의 레코드가 인출됨.

declare
    --VArray자료형 선언. 배열에 저장될 값은 사원아이디 컬럼을 참조하여 생성함.
    type vaType1 is
        array(6) of employees.employee_id%Type;
    --배열 변수 선언 및 초기화
    va_one vaType1 := vaType1('','','','','','');
    cnt number := 1;
begin
    /*
    Java의 개선된 for문과 비슷하게 쿼리의 결과셋 갯수만큼 자동으로 반복하는
    형태로 사용한다. select절의 employee_id가 변수 i에 할당되고 이를 통해 추출할수있다.
    */
    for i in (select employee_id from employees where department_id=100) loop
        --추출한 데이터ㄴ를 배열에 저장한다.
        va_one(cnt) := i.employee_id;
        cnt := cnt + 1;
    end loop;
    --출력
    for j in 1 .. va_one.count loop
        dbms_output.put_line(va_one(j));
    end loop;
end;
/

/*
3.중첩테이블(Nested table)
    : VArray와 비슷한 구조의 배열로써 배열의 크기를 명시하지 않으므로 동적으로
    배열의 크기가 설정된다. 여기서 말하는 테이블은 자료가 저장되는 실제 테이블이
    아니라 컬렉션의 한 종류를 의미한다.
    형식] Type 중첩테이블명 Is
            Table Of 값의타입;
*/
declare
    --중첩테이블의 자료형을 생성한 후 변수 선언
    type ntType is
        table of varchar2(30);
    nt_array ntType;
begin
    --생성자를 통해 값 할당(여기서 크기 4인 중첩테이블이 생성된다.)
    nt_array := ntType('첫번째', '두번째', '세번째', '');
    
    dbms_output.put_line(nt_array(1));
    dbms_output.put_line(nt_array(1));
    dbms_output.put_line(nt_array(1));
    nt_array(4) := '네번째값할당';
    dbms_output.put_line(nt_array(1));--4번째값까지는 정상적으로 할당 및 출력된다.
    
    --에러발생됨. 첨자가 갯수를 넘었습니다.
    --nt_array(5) := '다섯번째값??할당??';
    
    --크기를 확정할때는 생성자를 통해 배열의 크기를 동적으로 확장한다.
    nt_array := ntType('1a','2b','3c','4d','5e','6f','7g');
    
    --크기 7인 중첩테이블 출력
    for i in 1 .. 7 loop
        dbms_output.put_line(nt_array(i));
    end loop;
end;
/

/*
시나리오] 중첩테이블과 for문을 통해 사원테이블의 
전체 레코드의 사원번호와 이름을 출력하시오.
*/
declare
    /*
    중첩테이블 자료형 선언 및 변수선언 : 사원테이블 전체 컬럼을 참조하는
        참조변수의 형태이므로 하나의 레코드(Row)를 저장할 수 있는 형태로 선언된다.
    */
    type ntType is
        table of employees%rowtype;
    nt_array ntType;
begin
    --크기를 지정하지 않고 생성자를 통해 초기화한다.
    nt_array := ntType();
    
    /*
    사원테이블의 레코드 수 만큼 반복하면서 레코드를 하나씩 변수 rec에 저장한다.
    커서처럼 동작하는 for문의 형태로 Java의 확장 for문처럼 사용되었다.
    */
    for rec in (select * from employees) loop
        --중첩테이블의 끝부분을 확장하면서 null을 삽입한다.
        nt_array.extend;
        --마지막 인덱스에 사원정보 레코드를 삽입한다.
        nt_array(nt_array.last) := rec;
    end loop;
    
    --중첩테이블의 첫번째 인덱스부터 마지막 인덱스까지 출력한다.
    for i in nt_array.first .. nt_array.last loop
        dbms_output.put_line(nt_array(i).employee_id||
            '>'||nt_array(i).first_name);
    end loop;
    
end;
/