/************
���ϸ� : Or15PLSQL.sql
PL/SQL
���� : ����Ŭ���� �����ϴ� ���α׷��� ���
*************/
/*
PL/SQL(Procedural Language)
    : �Ϲ� ���α׷��� ���� ������ �ִ� ��Ҹ� ��� ������ ������ DB������
    ó���ϱ� ���� ����ȭ�� ����̴�
*/
--HR�������� �ǽ��մϴ�. 

--ȭ��� ������ ����ϰ� ������ on���� �����Ѵ�. off�϶��� ��µ��� �ʴ´�. 
set serveroutput on;
declare --����� : �ַ� ������ �����Ѵ�. 
    cnt number; --����Ÿ���� ���� ����
begin --����� : begin~end�� ���̿� ������ ���� ������ ����Ѵ�. 
    cnt := 10; --������ 10�� �Ҵ��Ѵ�. ���Կ����ڴ� := �� ����Ѵ�. 
    cnt := cnt + 1;
    dbms_output.put_line(cnt);--java�� println()�� �����ϴ�. 
end;
/
/*
    PL/SQL ������ ������ �ݵ�� /�� �ٿ��� �ϴµ�, ���� 
    ������ ȣ��Ʈȯ������ ���������� ���Ѵ�. �� PL/SQL������ 
    Ż���ϱ����� �ʿ��ϴ�. 
    ȣ��Ʈȯ���̶� �������� �Է��ϱ� ���� SQL> ���¸� ���Ѵ�. 
*/

/*
�ó�����] ������̺��� �����ȣ�� 120�� ����� �̸��� ����ó�� ����ϴ�
    PL/SQL���� �ۼ��Ͻÿ�.
*/
select concat(first_name||' ', last_name), phone_number
from employees where employee_id=120;

declare
    /*
    ����ο��� ������ �����Ҷ��� ���̺� �����ÿ� �����ϰ� �����Ѵ�. 
    => ������ �ڷ���(ũ��)
    ��, ������ ������ �÷��� Ÿ�԰� ũ�⸦ �����Ͽ� �������ִ°��� ����. 
    �Ʒ� �̸��� ��� �ΰ��� �÷��� ������ �����̹Ƿ� ���� �� �˳��� ũ��� 
    �������ִ°��� ����. 
    */
    empName varchar2(50);
    empPhone varchar2(20);
begin
    /*
    ����� : select������ ������ ����� ����ο��� ������ ������ 1:1��
        �����Ͽ� ���� �����Ѵ�. �̶� into�� ����Ѵ�. 
    */
    select concat(first_name||' ', last_name), phone_number
        into empName, empPhone
    from employees where employee_id=120;
    
    dbms_output.put_line(empName||' '||empPhone);
end;
/

/*
�ó�����] �μ���ȣ 10�� ����� �����ȣ, �޿�, �μ���ȣ�� �����ͼ� 
    �Ʒ� ������ ������ ȭ��� ����ϴ� PL/SQL���� �ۼ��Ͻÿ�. 
    ��, ������ �������̺��� �ڷ����� �����ϴ� '��������'�� �����Ͻÿ�.

    �������� : Ư�� ���̺��� Ư�� �÷��� �����ϴ� �����ν� 
        ������ �ڷ����� ũ��� �����ϰ� ������ ����Ѵ�. 
        ����] ���̺��.�÷���%type
            => ���̺��� '�ϳ�'�� �÷����� �����Ѵ�.
*/
--�ó������� ���ǿ� �´� select���� �ۼ��Ѵ�.
select employee_id, salary, department_id
from employees where department_id=10;

declare
    --������̺��� Ư�� �÷��� Ÿ�԰� ũ�⸦ �״�� �����ϴ� ���������� �����Ѵ�. 
    eid employees.employee_id%type; --number(6)
    sal employees.salary%type; --number(8,2)
    deptid employees.department_id%type;--number(4)�� �����ϴ�. 
begin
    --select�� ����� into�� ���� ������ ������ �Ҵ��Ѵ�. 
    select employee_id, salary, department_id
        into eid, sal, deptid
    from employees where department_id=10;
    
    dbms_output.put_line(eid||' '||sal||' '||deptid);
end;
/

/*
�ó�����] �����ȣ�� 100�� ����� ���ڵ带 �����ͼ� emp_row������ ��ü�÷���
������ �� ȭ�鿡 ���� ������ ����Ͻÿ�.
��, emp_row�� ������̺��� ��ü�÷��� ������ �� �ִ� ���������� �����ؾ��Ѵ�.
������� : �����ȣ, �̸�, �̸���, �޿�
*/
declare
    /*
    ��ü�÷��� �����ϴ� �������� : ���̺�� �ڿ� %rowtype�� �ٿ���
        �����Ѵ�. 
    */
    emp_row employees%rowtype;
begin
    /*
    ���ϵ�ī�� *�� ���� ���� ��ü�÷��� ���� emp_row�� �Ѳ����� �����Ѵ�. 
    */
    select * into emp_row
    from employees where employee_id=100;
    /*
    emp_row���� ��ü�÷��� ������ ����ǹǷ� ��½ÿ��� ������.�÷���
    ���·� ����ؾ� �Ѵ�. 
    */
    dbms_output.put_line(emp_row.employee_id||' '||
                        emp_row.first_name||' '||
                        emp_row.email||' '||
                        emp_row.salary);
end;
/



/*
���պ���
    : class�� �����ϵ� �ʿ��� �ڷ����� ��� �����ϴ� ����
    
    �Ʒ��� 2���� �ڷ����� ���� ���պ����� �����ϰ� �ִ�. 
    Ư�� �÷��� �״�� ����Ҷ��� �������� %type���·� �����ϰ�
    �÷��� ��ġ�ų� �����ؾ� �� ��� ���ǻ����� �����ϴ�. 
    ����]
        type ���պ����ڷ��� is record(
            �÷���1 �ڷ���1,
            �÷���2 ��������%type ....
        );
*/
/*
�ó�����] �����ȣ, �̸�(first_name+last_name), ���������� ������ �� �ִ� 
���պ����� ������ ��, 100�� ����� ������ ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
*/
--�������ۼ�
select employee_id, first_name||' '||last_name, job_id
from employees where employee_id=100;

declare
    --3���� ���� ������ �� �ִ� �����ڷ����� �����Ѵ�. 
    type emp_3type is record(
        emp_id employees.employee_id%type, /*���� �÷��� �����ϴ� �������� */
        emp_name varchar2(50), /* ���Ӱ� ������ ���� */
        emp_job employees.job_id%type
    );
    --�տ��� ������ �����ڷ����� ���� ������ ���պ���. 3���� �÷��� �����Ҽ� �ִ�. 
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
��������]�Ʒ� ������ ���� PL/SQL���� �ۼ��Ͻÿ�.
1.���պ�������
- �������̺� : employees
- ���պ����ڷ����� �̸� : empTypes
        ���1 : emp_id -> �����ȣ
        ���2 : emp_name -> �������ü�̸�(�̸�+��)
        ���3 : emp_salary -> �޿�
        ���4 : emp_percent -> ���ʽ���
������ ������ �ڷ����� �̿��Ͽ� ���պ��� rec2�� ������ �����ȣ 100���� ������ �Ҵ��Ѵ�.
2.1�� ������ ����Ѵ�.
3.�� ������ �Ϸ����� ġȯ�����ڸ� ����Ͽ� �����ȣ�� ����ڷκ��� �Է¹��� �� 
�ش� ����� ������ ����Ҽ��ֵ��� �����Ͻÿ�.[����
]
*/
--������ ���ǿ� �´� select ������ �ۼ�
 select 
     employee_id, first_name||' '||last_name , salary, nvl(COMMISSION_PCT,0)
         into rec2
from employees where employee_id=100;

--��°���� ȭ��� ǥ���ϱ� ���� ������� ù ����� �ݵ�� �ʿ���.
set serveroutput on;

declare
    --4���� ����� ���� ���պ����ڷ��� ����
    type empType is record(
        emp_id employees.employee_id%type,
        emp_name VARCHAR2(50),
        emp_salary employees.salary%type,
        emp_percent employees.COMMISSION_PCT%type
    );
    --���պ����ڷ����� ���� ���� ����
    rec2 empType;

begin
    select 
        employee_id, first_name||' '||last_name , salary, nvl(COMMISSION_PCT,0)
            into rec2
    from employees where employee_id=100;
    dbms_output.put_line('�����ȣ/ �����/ �޿�/ ���ʽ���');
    dbms_output.put_line(rec2.emp_id||' '||
                         rec2.emp_name||' '||
                         rec2.emp_salary||' '||
                         rec2.emp_percent);
end;
/

/*
ġȯ������ : PL/SQL���� ����ڷκ��� �����͸� �Է¹����� ����ϴ� �����ڷ�
�����տ� &�� �ٿ��ָ� �ȴ�. ����� �Է�â�� ���.
*/
--�տ��� �ۼ��ߴ� PL/SQL�� 3������ �䱸�� ġȯ�����ڷ� �����ȣ�� �Է¹޾� ó���Ѵ�.
--������ ������ �״�� ������ �� �����Ѵ�.
declare
    --4���� ����� ���� ���պ����ڷ��� ����
    type empType is record(
        emp_id employees.employee_id%type,
        emp_name VARCHAR2(50),
        emp_salary employees.salary%type,
        emp_percent employees.COMMISSION_PCT%type
    );
    --���պ����ڷ����� ���� ���� ����
    rec2 empType;
    --ġȯ�����ڸ� ���� �Է¹��� ���� �Ҵ�޴� ����
    inputNum number(3) := &inputNum;
begin
    select 
        employee_id, first_name||' '||last_name , salary, nvl(COMMISSION_PCT,0)
            into rec2
    from employees where employee_id= inputNum;/*�����ȣ�� ������ ��ü�Ѵ�.*/
    dbms_output.put_line('�����ȣ/ �����/ �޿�/ ���ʽ���');
    dbms_output.put_line(rec2.emp_id||' '||
                         rec2.emp_name||' '||
                         rec2.emp_salary||' '||
                         rec2.emp_percent);
end;
/

/*
���ε庯��
    : ȣ��Ʈȯ�ܿ��� ����� �����ν� �� PL/SQL�����̴�.
    ȣ��Ʈȯ���̶� PL/SQL�� ���� ������ ������ �κ��� ���Ѵ�.
    �ܼ�(CMD)������ SQL> ���������Ʈ�� �ִ� ���¸� ���Ѵ�.
    
    ����] 
        var ������ �ڷ���;
        Ȥ��
        variable ������ �ڷ���;
*/
set serveroutput on;
--ȣ��Ʈȯ�濡�� ���ε庯�� ����
var return_var number;
--PL/SQl�ۼ�
declare 
    --����ο��� �̿Ͱ��� �ƹ������� �������� �ִ�.
begin 
    /*
    �Ϲݺ������� ������ ���� ���ε庯�� �տ��� :(�ݷ�)�� �߰��ؾ��Ѵ�.
    */
    :return_var := 999;
    dbms_output.put_line(:return_var);
end;
/

print return_var;
/*
    ȣ��Ʈȯ�濡�� ����Ҷ��� print���� ����Ѵ�.
    ����� ����� �ȵǸ� CMDâ���� Ȯ���غ��� ���������� ��µȤ���.
*/

---------------------------------------------------------------
--���(���ǹ�) : if��, case���� ���� ���ǹ��� �н�

--if�� : Ȧ���� ¦���� �Ǵ��ϴ� if��

--�ó�����] ������ ����� ���ڰ� Ȧ�� or ¦������ �Ǵ��ϴ� PL/SQL�� �ۼ��Ͻÿ�.

declare
    --����ο��� ����Ÿ���� ���� ����
    num number;
begin
    num := 10;
    --mod(����, ����) : ������ ������ ���� �������� ��ȯ�ϴ� �Լ�
    if mod(num,2) = 0 then
        dbms_output.put_line(num ||'�� ¦��');
    else
        dbms_output.put_line(num ||'�� Ȧ��');
    end if;
end;
/

--�� ������ ġȯ�����ڸ� ���� ���ڸ� �Է¹��� �� �Ǵ��� �� �ֵ��� �����Ͻÿ�.
declare
    --ġȯ�����ڴ� ����ο� ����� �� �ִ�.
    num number := &num;
begin
    --num := 10; --����ο��� ġȯ�����ڸ� ���� �Է¹����Ƿ� �Ҵ� �ʿ����

    if mod(num,2) = 0 then
        dbms_output.put_line(num ||'�� ¦��');
    else
        dbms_output.put_line(num ||'�� Ȧ��');
    end if;
end;
/
/*
�ó�����] �����ȣ�� ����ڷκ��� �Է¹��� �� �ش� ����� ��μ�����
�ٹ��ϴ����� ����ϴ� PL/SQL���� �ۼ��Ͻÿ�. ��, if~elsif���� ����Ͽ�
�����Ͻÿ�.
*/
declare
    --ġȯ�����ڸ� ���� �����ȣ�� �Է¹���
    emp_id employees.employee_id%type := &emp_id;
    emp_name varchar2(50);
    emp_dept employees.department_id%type;
    --�μ����� ����� ���ÿ� �ʱ�ȭ�Ѵ�. ��ġ�ϴ� ������ ���°�� �ʱ갪���� ����Ѵ�.
    dept_name varchar2(30) := '�μ���������';
begin
    select employee_id, last_name, department_id
        into emp_id, emp_name, emp_dept
    from employees
    where employee_id = emp_id;--�Է¹��� �����ȣ�� ������ �����Ѵ�.
    
    /*
    �������� ������ ����� ��� java�� ���� else if�� ����ϴ°��� �ƴ϶�
    elsif�� ����ؾ� �Ѵ�. ���� �߰�ȣ ��� then�� end if; �� ���ȴ�.
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
    
    dbms_output.put_line('�����ȣ'|| emp_id ||'������');
    dbms_output.put_line('�̸�:'|| emp_name
            ||', �μ���ȣ:'|| emp_dept
            ||', �μ���:'|| dept_name );
end;
/

/*
�ó�����] �տ��� if~elsif�� �ۼ��� PL/SQL���� case~when������ �����Ͻÿ�.
*/
declare
    emp_id employees.employee_id%type := &emp_id;
    emp_name varchar2(50);
    emp_dept employees.department_id%type;
    dept_name varchar2(30) := '�μ���������';
begin
    select employee_id, last_name, department_id
        into emp_id, emp_name, emp_dept
    from employees
    where employee_id = emp_id;
    
    /*
    case~when���� if���� �ٸ����� �Ҵ��� ������ ���� ������ �� ���峻����
    ������ �Ǵ��Ͽ� �ϳ��� ���� �Ҵ��ϴ� ����̴�. ���� ������ �ߺ�����
    ������� �ʾƵ� �ȴ�.
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
    
    dbms_output.put_line('�����ȣ'|| emp_id ||'������');
    dbms_output.put_line('�̸�:'|| emp_name
            ||', �μ���ȣ:'|| emp_dept
            ||', �μ���:'|| dept_name );
end;
/

/*
case�� : java�� switch���� ����� ���ǹ�
����]
    case ����
        when ��1 then '�Ҵ簪1'
        when ��2 then '�Ҵ簪2'
        ....��N
    end;
*/

-----------------------------------------------
--���(�ݺ���)
/*
�ݺ���1 : Basic loop��
    Java�� do~while���� ���� ����üũ���� �ϴ� loop�� ������ �� Ż��������
    �ɶ����� �ݺ��Ѵ�. Ż��ÿ��� exit�� ����Ѵ�.
*/


declare
    num number := 0;
begin
    loop
        --0~10���� ����Ѵ�.
        dbms_output.put_line(num);
        num := num +1;
        --num�� 10�� �ʰ��ϸ� loop���� Ż���Ѵ�.
        exit when (num>10); --exit�� Java�� break�� ������ ��Ȱ
    end loop;
end;
/
/*
�ó�����] Basic loop������ 1���� 10������ ������ ���� ���ϴ� 
    ���α׷��� �ۼ��Ͻÿ�.
*/
declare
    i number := 1; --������ų ����
    sumNum number := 0; --������ ����
    --���������� sum�� ����Ҽ� ����. �����(�׷��Լ�)�̹Ƿ� ������ �߻��Ѵ�.
begin
    /*
    PL/SQL������ ���մ��Կ�����, ���������ڰ� �����Ƿ� ������ Ȥ�� ������ ������
    �Ʒ��� ���� �����Ѵ�.
    */
    loop
        --�����ϴ� ����i�� �����ؼ� ���Ѵ�.
        sumNum := sumNum +i;
        --����i�� 1�� �����Ѵ�.
        i := i + 1;
        exit when (i>10);
    end loop;
    dbms_output.put_line('1~10����������:'|| sumNum);
end;
/

/*
�ݺ���2 : whole��
    Basic loop �ʹ� �ٸ��� ������ ���� Ȯ���� �� �����Ѵ�.
    ��, ���ǿ� ���� �ʴ´ٸ� �ѹ��� ������� ������ �ִ�.
*/
declare
    num1 number := 0;
begin
    --while�� ������ ������ ���� Ȯ���Ѵ�.
    while num1<11 loop
        --0~10���� ����Ѵ�.
        dbms_output.put_line('�̹����ڴ�:'|| num1);
        num1 := num1 + 1;
    end loop;
end;
/

/*
�ó�����] while loop������ ������ ���� ����� ����Ͻÿ�.
*
**
***
****
*****
*/
declare
    -- *�� �����ؼ� ������ ������ ���� ����
    starStr varchar2(100);
    -- �ݺ��� ���� ���� ���� �� �ʱ�ȭ
    i number := 1;
    j number := 1;
begin
    while i <= 5 loop
        while j <= 5 loop
            starStr := starStr || '*';
            --������ false�϶� ���� ����� while���� Ż��
            exit when (j<=i);
         j := j+1;
        end loop;
        dbms_output.put_line(starStr);
        i := i + 1;
        j := 1;--j�� 1�� �ٽ� �ʱ�ȭ
    end loop;
end;
/

/*
�ó�����] while loop������ 1���� 10������ ������ ���� ���ϴ� ���α׷��� �ۼ��Ͻÿ�. 
*/
declare
    i number := 1;
    sumNum number := 0;
begin
    while i<=10 loop
        sumNum := sumNum + i;
        i := i + 1;
    end loop;
    dbms_output.put_line('1~10����������:'|| sumNum);
end;
/

/*
�ݺ���3 : for��
    �ݺ��� Ƚ���� �����Ͽ� ����� �� �ִ� �ݺ�������, �ݺ��� ���� ������
    ������ �������� �ʾƵ� �ȴ�. �׷��Ƿ� Ư���� ������ ���ٸ� �����(declare)��
    ������� �ʾƵ� �ȴ�.
*/
declare
begin
    for num2 in 0 .. 10 loop
        dbms_output.put_line('for��¯�ε�:'|| Num2);
    end loop;
end;
/

begin
    for num3 in reverse 0 .. 10 loop
        dbms_output.put_line('�Ųٷ�for��¯�ε�:'|| Num3);
    end loop;
end;
/

/*
��������] for loop������ �������� ����ϴ� ���α׷��� �ۼ��Ͻÿ�. 
*/

--�ٹٲ� �Ǵ� ����
begin
    --���� 2~9����
    for dan in 2 .. 9 loop
        dbms_output.put_line(dan||'��');
        --���� 1~9���� 
        for su in 1 .. 9 loop
            --�������� ��� ����ϰ� �ٹٲ�ó��
            dbms_output.put_line(dan||'*'||su||'='||(dan*su));
        end loop;
    end loop;
end;
/

--�ٹٲ� ���� ����
declare
    --�����ܿ��� �ϳ��� ���� �����ϱ� ���� ����
    guguStr varchar2(1000);
begin
    --�ܿ� �ش��ϴ� loop
    for dan in 2 .. 9 loop
        --���� �ش��ϴ� loop
        for su in 1 .. 9 loop
            --�ϳ��� ���� ������������ �����ؼ� �����Ѵ�.
            guguStr := guguStr || dan ||'*'|| su ||'='|| (dan*su) ||' ';
        end loop;
        --�ϳ��� ���� ������ �Ϸ�Ǹ� ����Ѵ�.
        dbms_output.put_line(guguStr);
        --�� ���� ���� �����ϱ� ���� �ʱ�ȭ�Ѵ�.
        guguStr := '';
    end loop;
end;
/


/*
Ŀ��(Curosr)
    : select ���忡 ���� �������� ��ȯ�Ǵ� ��� �� �࿡ �����ϱ� ���� ��ü
    ������]
        Cursor Ŀ���� Is
            Select ������. �� into���� ���� ���·� ����Ѵ�.
        
    Open Cursor
        : ������ �����϶�� �ǹ�. �� Open�Ҷ� Cursor������� select������ ����Ǿ�
        ������� ��Եȴ�. Cursor�� �� ������� ù��°�࿡ ��ġ�ϰ� �ȴ�.
    Fetch~Into~
        :����¿��� �ϳ��� ���� �о���̴� �۾����� ������� ����(Fetch)�Ŀ�
        Cursor�� ���������� �̵��Ѵ�.
    Close Cursor
        : Ŀ�� �ݱ�� ������� �ڿ��� �ݳ��Ѵ�. select������ ��� ó���� �� Cursor��
        �ݾ��ش�.
    Cursor�� �Ӽ�
        %Found : ���� �ֱ��� ����(Fetch)�� ���� Return �ϸ� True, �ƴϸ�
            False�� ��ȯ�Ѵ�.
        %RowCount : ���ݱ��� Return�� ���� ������ ��ȯ�Ѵ�.
*/

/*
�ó�����] �μ����̺��� ���ڵ带 Cursor�� ���� ����ϴ� PL/SQL���� �ۼ��Ͻÿ�.
*/
declare
    --�μ����̺��� ��ü �÷��� �����ϴ� �������� ����
    v_dept departments%rowtype;
    --Ŀ������ : �μ����̺��� ��� ���ڵ带 ��ȸ�ϴ� select ������ �ۼ�
    --          into���� ����.
    cursor cur1 is
        select 
            department_id, department_name, location_id
        from departments;
begin
    /*
    �ش� �������� �����ؼ� �����(ResultSet)�� �����´�. ������̶�
    ����(����)���� ������ �� ��ȯ�Ǵ� ���ڵ��� ����� ���Ѵ�.
    */
    open cur1;
    --basic���������� ���� ������� ������ŭ �ݺ��Ͽ� �����Ѵ�.
    loop
        --�� �÷��� ���� ���������� �����Ѵ�.
        fetch cur1 into
            v_dept.department_id,
            v_dept.department_name,
            v_dept.location_id;
        --Ż���������� �� �̻� ������ ���� ������ exit�� ����ȴ�.
        exit when cur1%notfound;
        
        dbms_output.put_line(v_dept.department_id||' '||
                        v_dept.department_name||' '||
                        v_dept.location_id);
    
    end loop;
    --Ŀ���� �ڿ��ݳ�
    close cur1;
end;
/

/*
�ó�����] Cursor�� ����Ͽ� ������̺��� Ŀ�̼��� null�� �ƴ� 
����� �����ȣ, �̸�, �޿��� ����Ͻÿ�. 
��½ÿ��� �̸��� ������������ �����Ͻÿ�.
*/
--������ ���ǿ� �´� ������ �ۼ�
select * from employees where commission_pct is not null;

declare
    --�ۼ��� ������ ���� Ŀ���� �����Ѵ�.
    cursor curEmp is
        select employee_id, last_name, salary
        from employees
        where commission_pct is not null
        order by last_name asc;
    --������̺��� ��ü�÷��� �����ϴ� �������� ����
    varEmp employees%rowType;
begin
    --Ŀ���� �����Ͽ� �������� �����Ѵ�.
    open curEmp;
    --Basic loop���� ���� Ŀ���� ����� ������� �����Ѵ�.
    loop
        fetch curEmp
            into varEmp.employee_id, varEmp.last_name, varEmp.salary;
        --������ ������� ������ loop���� Ż���Ѵ�.
        exit when curEmp%notFound;
        dbms_output.put_line(varEmp.employee_id ||' '||
                                varEmp.last_name||' '||
                                varEmp.salary);
    end loop;
    --Ŀ���� �ݾ��ش�.
    close curEmp;
end;
/
select * from employees where last_name='Abel';


/*
�÷���(�迭)
    : �Ϲ� ���α׷��� ���� ����ϴ� �迭Ÿ���� PL/SQL������ ���̺� Ÿ���̶�� �Ѵ�.
    1����, 2���� �迭�� �����غ��� ���̺�(ǥ)�� ���� �����̱� �����̴�.
����
    -�����迭
    -VArray
    -��ø���̺�

1.�����迭(Associative Array)
    : Ű�� �� �ѽ����� ������ �÷������� Java�� �ؽøʰ� ���� �����̴�.
    Key : �ڷ����� �ַ� ���ڸ� ����ϸ� binary_integer, pls_integer�� �ַ� ���ȴ�.
        �� �ΰ��� Ÿ���� number���� ũ��� �۰�, ������꿡 ���� Ư¡�� ������.
    value : �ڷ����� �������̸� �ַ� varchar2�� ���ȴ�
    
    ����] Type �����迭�ڷ��� Is
            Table of �����迭 �� Ÿ��
            Index by �����迭 Ű Ÿ��
*/


/*
�ó�����] ������ ���ǿ� �´� �����迭�� ������ �� ���� �Ҵ��Ͻÿ�.
    �����迭 �ڷ��� �� : avType, �����ڷ���:������, Ű���ڷ���:������
    key : girl, boy
    value : Ʈ���̽�, ��ź�ҳ��
    ������ : var_array
*/
declare
    --�����迭 �ڷ��� ����
    Type avType Is
        Table Of varchar2(30) --value(��)�� �ڷ��� ����
        Index By varchar2(10); --key(Ű, �ε���)�� �ڷ��� ����
    --�����迭 Ÿ���� ��������
    var_array avType;
begin
    --���������� �� �Ҵ�
    var_array('girl') := 'Ʈ���̽�';
    var_array('boy') := '��ź�ҳ��';
    --���
    dbms_output.put_line(var_array('girl'));
    dbms_output.put_line(var_array('boy'));
end;
/

/*
�ó�����] 100�� �μ��� �ٹ��ϴ� ����� �̸��� �����ϴ� �����迭�� �����Ͻÿ�.     
key�� ����, value�� full_name ���� �����Ͻÿ�.
*/
--100���μ��� �ٹ��ϴ� ���� ���
select * from employees where department_id=100;--6��
--Full name�� ����ϱ� ���� ������ �ۼ�
select first_name||' '||last_name
    from employees where department_id=100;
--������ ������ ���� �������� �ټ����� ����Ǿ����Ƿ� Cursor�� ����ؾ��Ѵ�.
declare
    --�������� ���� Ŀ�� ����
    cursor emp_cur is 
        select first_name||' '||last_name from employees
        where department_id=100;
    --�����迭 �ڷ��� ����(key:������, value:������)    
    Type nameAvType Is
        Table Of varchar2(30)
        Index By binary_integer;
    --�ڷ����� ������� ���� ����
    names_arr nameAvType;
    --����� �̸��� �ε����� ����� ���� ����
    fname varchar2(50);
    idx number := 1;
begin
    /*
    Ŀ���� �����Ͽ� �������� ������ �� ���� ������� ������ŭ �ݺ��Ͽ� 
    ������� �����Ѵ�.
    */
    open emp_cur;
    loop
        fetch emp_cur into fname;
        exit when emp_cur%NotFound;
        --�����迭 ������ ����̸��� �Է��Ѵ�.
        names_arr(idx) := fname;
        --Ű�� ���� �ε��� ����
        idx := idx +1;
    end loop;
    close emp_cur;
    
    /*
    �����迭.count : �����迭�� ����� ���� ��ȯ
    */
    for i in 1 .. names_arr.count loop
        dbms_output.put_line(names_arr(i));
    end loop;
end;
/

/*
2.VArray(Variable Array)
    : �������̸� ���� �迭�ν� �Ϲ� ���α׷��� ���� ����ϴ� �迭�� �����ϴ�.
    ũ�⿡ ������ �־ �����Ҷ� ũ��(�����ǰ���)�� �����ϸ� �̺��� ū �迭��
    ���� �� ����.
    ����] Type �迭Ÿ�Ը� Is
                Array(�迭ũ��) Of ���Ұ���Ÿ��;
*/
declare
    --VArrayŸ�� ���� : ũ��� 5, ������ �����ʹ� ���������� �����Ѵ�.
    type vaType is
        array(5) of varchar2(20);
    --VArray�� �迭���� ����
    v_arr vaType;
    cnt number := 0;
begin
    --�����ڸ� ���� ���� �ʱ�ȭ(�� 5���� 3���� �Ҵ��Ѵ�.)
    v_arr := vaType('First','Second','Third','','');
    
    --Basic loop���� ���� �迭�� ���Ҹ� ����Ѵ�.(���ε����� 1���� ������)
    loop
        cnt := cnt + 1;
        --Ż�������� when��� if�� ����Ҽ��� �ִ�.
        if cnt>5 then
            exit;
        end if;
        --�迭ó�� �ε����� ���� ����Ѵ�.
        dbms_output.put_line(v_arr(cnt));
    end loop;
    
    --�迭�� ���� ���Ҵ�
    v_arr(3) := '�츮��';
    v_arr(4) := 'JAVA';
    v_arr(5) := '�����ڴ�';
    --for������ ���
    for i in 1 .. 5 loop
        dbms_output.put_line(v_arr(i));
    end loop;
end;
/

/*
�ó�����] 100�� �μ��� �ٹ��ϴ� ����� �̸��� �����Ͽ� VArray�� ������ ��
    ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
*/
select * from employees where department_id=100;--6���� ���ڵ尡 �����.

declare
    --VArray�ڷ��� ����. �迭�� ����� ���� ������̵� �÷��� �����Ͽ� ������.
    type vaType1 is
        array(6) of employees.employee_id%Type;
    --�迭 ���� ���� �� �ʱ�ȭ
    va_one vaType1 := vaType1('','','','','','');
    cnt number := 1;
begin
    /*
    Java�� ������ for���� ����ϰ� ������ ����� ������ŭ �ڵ����� �ݺ��ϴ�
    ���·� ����Ѵ�. select���� employee_id�� ���� i�� �Ҵ�ǰ� �̸� ���� �����Ҽ��ִ�.
    */
    for i in (select employee_id from employees where department_id=100) loop
        --������ �����ͤ��� �迭�� �����Ѵ�.
        va_one(cnt) := i.employee_id;
        cnt := cnt + 1;
    end loop;
    --���
    for j in 1 .. va_one.count loop
        dbms_output.put_line(va_one(j));
    end loop;
end;
/

/*
3.��ø���̺�(Nested table)
    : VArray�� ����� ������ �迭�ν� �迭�� ũ�⸦ ������� �����Ƿ� ��������
    �迭�� ũ�Ⱑ �����ȴ�. ���⼭ ���ϴ� ���̺��� �ڷᰡ ����Ǵ� ���� ���̺���
    �ƴ϶� �÷����� �� ������ �ǹ��Ѵ�.
    ����] Type ��ø���̺�� Is
            Table Of ����Ÿ��;
*/
declare
    --��ø���̺��� �ڷ����� ������ �� ���� ����
    type ntType is
        table of varchar2(30);
    nt_array ntType;
begin
    --�����ڸ� ���� �� �Ҵ�(���⼭ ũ�� 4�� ��ø���̺��� �����ȴ�.)
    nt_array := ntType('ù��°', '�ι�°', '����°', '');
    
    dbms_output.put_line(nt_array(1));
    dbms_output.put_line(nt_array(1));
    dbms_output.put_line(nt_array(1));
    nt_array(4) := '�׹�°���Ҵ�';
    dbms_output.put_line(nt_array(1));--4��°�������� ���������� �Ҵ� �� ��µȴ�.
    
    --�����߻���. ÷�ڰ� ������ �Ѿ����ϴ�.
    --nt_array(5) := '�ټ���°��??�Ҵ�??';
    
    --ũ�⸦ Ȯ���Ҷ��� �����ڸ� ���� �迭�� ũ�⸦ �������� Ȯ���Ѵ�.
    nt_array := ntType('1a','2b','3c','4d','5e','6f','7g');
    
    --ũ�� 7�� ��ø���̺� ���
    for i in 1 .. 7 loop
        dbms_output.put_line(nt_array(i));
    end loop;
end;
/

/*
�ó�����] ��ø���̺�� for���� ���� ������̺��� 
��ü ���ڵ��� �����ȣ�� �̸��� ����Ͻÿ�.
*/
declare
    /*
    ��ø���̺� �ڷ��� ���� �� �������� : ������̺� ��ü �÷��� �����ϴ�
        ���������� �����̹Ƿ� �ϳ��� ���ڵ�(Row)�� ������ �� �ִ� ���·� ����ȴ�.
    */
    type ntType is
        table of employees%rowtype;
    nt_array ntType;
begin
    --ũ�⸦ �������� �ʰ� �����ڸ� ���� �ʱ�ȭ�Ѵ�.
    nt_array := ntType();
    
    /*
    ������̺��� ���ڵ� �� ��ŭ �ݺ��ϸ鼭 ���ڵ带 �ϳ��� ���� rec�� �����Ѵ�.
    Ŀ��ó�� �����ϴ� for���� ���·� Java�� Ȯ�� for��ó�� ���Ǿ���.
    */
    for rec in (select * from employees) loop
        --��ø���̺��� ���κ��� Ȯ���ϸ鼭 null�� �����Ѵ�.
        nt_array.extend;
        --������ �ε����� ������� ���ڵ带 �����Ѵ�.
        nt_array(nt_array.last) := rec;
    end loop;
    
    --��ø���̺��� ù��° �ε������� ������ �ε������� ����Ѵ�.
    for i in nt_array.first .. nt_array.last loop
        dbms_output.put_line(nt_array(i).employee_id||
            '>'||nt_array(i).first_name);
    end loop;
    
end;
/