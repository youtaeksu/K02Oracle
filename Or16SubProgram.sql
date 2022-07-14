/************
���ϸ� : Or16SubProgram.sql
�������α׷�
���� : �������ν���, �Լ� �׸��� ���ν����� ������ Ʈ���Ÿ� �н�
*************/

/*
�������α׷�(Sub Program)
-PL/SQL������ ���ν����� �Լ���� �ΰ��� ������ �������α׷����ִ�.
-Select�� �����ؼ� �ٸ� DML���� �̿��Ͽ� ���α׷������� ��Ҹ� ����
��밡���ϴ�.
-Ʈ���Ŵ� ���ν����� �������� Ư�� ���̺� ���ڵ��� ��ȭ�� �������
�ڵ����� ����ȴ�.
-�Լ��� �������� �Ϻκ����� ����ϱ� ���� �����Ѵ�. �� �ܺ� ���α׷�����
ȣ���ϴ� ���� ���� ����.
-���ν����� �ܺ� ���α׷����� ȣ���ϱ� ���� �����Ѵ�. ���� Java, JSP���
������ ȣ��� ������ ������ ������ �� �ִ�.
*/

/*
�������ν���(Stroed Procedure)
-���ν����� return���� ���� ��� out �Ķ���͸� ���� ���� ��ȯ�Ѵ�.
-���ȼ��� ���� �� �ְ� ��Ʈ��ũ�� ���ϸ� ���� �� �ִ�.
����] create [or replace] procedure ���ν�����
      [(�Ű����� in �ڷ���, �Ű����� out �ڷ���)]
      is [��������]
      begin
        ���๮��;      
      end;
�� �Ķ���� ������ �ڷ����� ����ϰ�, ũ��� ������� �ʴ´�.
*/

/*
�ó�����] 100�� ����� �޿��� select�Ͽ� ����ϴ� �������ν����� �����Ͻÿ�.
*/

create or replace procedure pcd_emp_salary
is
    --�������� : ������̺��� �޿� �÷��� �����ϴ� ��������
    v_salary employees.salary%type;
begin
    --100�� ����� �޿��� ������ �Ҵ��Ѵ�. �̶� into���� ����Ѵ�.
    select salary into v_salary from employees where employee_id=100;
    dbms_output.put_line('�����ȣ 100�� �޿��� '||v_salary||'�Դϴ�');
end;
/
--�����ͻ������� Ȯ��(����� �빮�ڷ� ��ȯ�ȴ�)
select * from user_source where name like upper('%pcd_emp_salary%');      

--ù �����̶�� ���ʷ� �ѹ� �����ؾ��Ѵ�. .����� ȭ�鿡 ����Ѵ�.
set serveroutput on;

--���ν����� ������ ȣ��Ʈȯ�濡�� execute����� �̿��Ѵ�.
execute pcd_emp_salary;
      
/*
In�Ķ���͸� ����� ���ν��� ����

�ó�����] ����� �̸��� �Ű������� �޾Ƽ� ������̺��� ���ڵ带 ��ȸ�� ��
�ش����� �޿��� ����ϴ� ���ν����� ���� �� �����Ͻÿ�.
�ش� ������ in�Ķ���͸� ���� �� ó���Ѵ�.
����̸�(first_name) : Burce, Neena
*/
--���ν��� ������ In�Ķ���͸� �����Ѵ�. ������̺��� ����� �÷��� �����Ѵ�.
create or replace procedure pcd_in_param_salary
    (param_name in employees.first_name%type)
is
    /*
    PL/SQL������ declare�� ������ ����������, ���ν��������� is���� 
    �����Ѵ�. ������ �ʿ���°�� �������� �������� �ִ�.
    */
    valSalary number(10);
begin
    /*
    ���Ķ���ͷ� ���޵� ������� �������� �޿��� ���� �� ������ �Ҵ��Ѵ�.
    */
    select salary into valSalary
    from employees where first_name = param_name;
    
    dbms_output.put_line(param_name||'�� �޿��� '|| valSalary ||' �Դϴ�');
end;
/
--����� �̸��� �Ķ���ͷ� �����Ͽ� ���ν��� ȣ��
execute pcd_in_param_salary('Bruce');
execute pcd_in_param_salary('Neena');      

/*
Out�Ķ���͸� ����� ���ν��� ����

�ó�����] �� ������ �����ϰ� ������� �Ű������� ���޹޾Ƽ� �޿��� ��ȸ�ϴ�
���ν����� �����Ͻÿ�. ��, �޿��� out�Ķ���͸� ����Ͽ� ��ȯ �� ����Ͻÿ�.
*/
create or replace procedure pcd_out_param_salary
(
    param_name in varchar2,
    param_salary out employees.salary%type
) /* �ΰ��� ������ �Ķ���͸� �����Ѵ�. �Ϲݺ���, ���������� ���� ����ߴ�. */
is
    /*
    select�� ����� out �Ķ���Ϳ� ������ ���̹Ƿ� ������ ������
    �ʿ���� is���� ����д�. �̿Ͱ��� ���� �����ϴ�.
    */
begin
    /*
    In�Ķ���ʹ� where���� �������� ����ϰ�
    select�� ����� into������ Out�Ķ���Ϳ� �����Ѵ�.
    */
    select salary into param_salary
    from employees where first_name = param_name;   
end;
/
--ȣ��Ʈȯ�濡�� ���ε庯���� �����Ѵ�.
var v_salary varchar2(30); --var Ȥ�� variable �Ѵ� ����� �� �ִ�.
--���ν��� ȣ��� ������ �Ķ���͸� �����Ѵ�. Ư�� ���ε� ������ :�� �ٿ����Ѵ�.
--Out�Ķ������ param_salary�� ����� ���� ���ε庯�� v_salary�� ���޵ȴ�.
execute pcd_out_param_salary('Matthew', :v_salary);
--���ν��� ���� �� out�Ķ���͸� ���� ���޵� ���� ����Ѵ�.
print v_salary;


--�ǽ��� ���� employees���̺��� ���ڵ���� ��ü �����Ѵ�.
create table zcopy_employees
as
select * from employees;
--����Ǿ����� Ȯ���ϱ�
select * from zcopy_employees;
      
/*
�ó�����] 
�����ȣ�� �޿��� �Ű������� ���޹޾� �ش����� �޿��� �����ϰ�, 
���� ������ ���� ������ ��ȯ�޾Ƽ� ����ϴ� ���ν����� �ۼ��Ͻÿ�
*/
--in�Ķ���ʹ� �����ȣ��, �޿��� ������. out�Ķ���ʹ� ����� ���ǰ��� ��ȯ��.
create or replace procedure pcd_update_salary
    (
        p_empid in number,
        p_salary in number,
        rCount out number
    )
is
    --�߰����� ���� ������ �ʿ�����Ƿ� ����
begin
    --���� ������Ʈ�� ó���ϴ� ���������� In�Ķ���͸� ���� ���� �����Ѵ�.
    update zcopy_employees 
        set salary = p_salary
        where employee_id = p_empid;
        
    /*
    sql%notfound : �������� �� ����� ���� ������� true�� ��ȯ�Ѵ�.
        found�� �ݴ��� ��츦 ��ȯ�Ѵ�.
    sql%rowcount : �������� �� ���� ����� ���� ������ ��ȯ�Ѵ�.
    */
    if SQL%notfound then
        dbms_output.put_line(p_empid ||'��(��) ���»���Ӵ�');
    else
        dbms_output.put_line(SQL%rowcount ||'���� �ڷᰡ �����Ǿ�');
      
        --���� ����� ���� ������ ��ȯ�Ͽ� out�Ķ���Ϳ� �����Ѵ�.
        rCount := sql%rowcount;
    end if;
    /*
    ���� ��ȭ�� �ִ� Ŀ���� �����Ұ�� �ݵ�� commit�ؾ� ���� ���̺� ����Ǿ�
    oracle�ܺο��� Ȯ���� �� �ִ�.
    */
    commit;
end;
/
--���ν��� ������ ���� ���ε庯�� ����
variable r_count number;

--100�� ����� �̸��� �޿� Ȯ�� : Steven, 24000
select first_name, salary from zcopy_employees where employee_id=100;

--���ν��� ����(���ε庯������ �ݵ�� :�� �ٿ��ߵȴ�.)
execute pcd_update_salary(100, 30000, :r_count);

--update�� ����� ���� ���� Ȯ��      
print r_count;

--������Ʈ�� ������ Ȯ�� : steven, 30000
select first_name, salary from zcopy_employees where employee_id=100;

/*
2.�Լ�
-����ڰ� PL/SQL���� ����Ͽ� ����Ŭ���� �����ϴ� �����Լ��� ���� �����
�����Ѱ��̴�.
-�Լ��� In�Ķ���͸� ����� �� �ְ�, �ݵ�� ��ȯ�� ���� �ڷ����� ����ؾ��Ѵ�.
-���ν����� �������� ������� ���� �� ������, �Լ��� �ݵ�� �ϳ��� ����
��ȯ�ؾ��Ѵ�.
--�Լ��� �������� �Ϻκ����� ���ȴ�.
�� �Ķ���Ϳ� ��ȯŸ���� ����Ҷ� ũ��� ������� �ʴ´�.
*/

/*
�ó�����] 
2���� ������ ���޹޾Ƽ� �� ���������� ������ ���ؼ� �����
��ȯ�ϴ� �Լ��� �����Ͻÿ�.
���࿹) 2, 7 -> 2+3+4+5+6+7 = ??
*/
create or replace function calSumBetween (
    /* �Լ��� in�Ķ���͸� �����Ƿ� �ַ� �����Ѵ�. */
    num1 in number,
    num2 number
)
return
    --�Լ��� �ݵ�� ��ȯ���� �����Ƿ� ��ȯŸ���� ����ؾ��Ѵ�.(�ʼ�)
    number
is
    --��ȯ������ ����� ���� ����(����: �ʿ���ٸ� ������ �� �ִ�.)
    sumNum number;
begin
    sumNum := 0;
    --for���������� ���ڻ����� ���� ����� �� ��ȯ�Ѵ�.
    for i in num1 .. num2 loop
        sumNum := sumNum + i;
    end loop;
    
    return sumNum;
end;
/
--������1 : �������� �Ϻη� ����Ѵ�.
select calSumBetween(1,10) from dual;

--������2 : ���ε庯���� ���� ���������� �ַ� ���������� ����Ѵ�.
var hapText varchar2(30);
execute :hapText := calSumBetween(1, 100)
print hapText;

--�����ͻ��� 
select * from user_source where name=upper('calSumBetween');

/*
��������] 
����] �ֹι�ȣ�� ���޹޾Ƽ� ������ �Ǵ��ϴ� �Լ��� �����Ͻÿ�.
999999-1000000 -> '����' ��ȯ
999999-2000000 -> '����' ��ȯ
��, 2000�� ���� ����ڴ� 3�� ����, 4�� ������.
�Լ��� : findGender()
*/
--�ֹι�ȣ�� ���� �κ��� �ڶ�������� Ȯ��
select substr('999999-1000000',8,1) from dual;-- 1 ���
select substr('999999-2000000',8,1) from dual;-- 2 ���

--�ش� �Լ��� �ֹι�ȣ�� �������·� �޾Ƽ� ������ �Ǵ��Ѵ�.
create or replace function findGender(
    juminNum in varchar2
)
return/* ������ �Ǵ��� �� '����' Ȥ�� '����'�� ��ȯ�ϹǷ� ���������� ����*/ 
    varchar2 
is
    --�ֹι�ȣ���� ������ �ش��ϴ� ���ڸ� ����
    genderText varchar2(1);
    --������ ������ �� ��ȯ�� ����
    returnVal varchar2(10);
begin
    --���1 : substr()�� ��� ����Ѵ�.
    --in�Ķ���ͷ� ���޵Ǵ� �ֹι�ȣ�� ���� ������ Ȯ��
    --genderTxt := substr(juminNum,8,1) 
    
    --���2 : ������ �Ϻη� ������ �� into�� ���� �����Ѵ�.
    select substr(juminNum,8,1) into genderText from dual;
    
    if genderText='1' then 
        returnVal := '����';
    elsif genderText='2' then
        returnVal := '����';
    elsif genderText='3' then
        returnVal := '����';
    elsif genderText='4' then
        returnVal := '����';
    end if;
    return returnVal;
end;
/
--�Ǹ�Ȯ��
select findGender('999999-1000000') from dual; --���� ���
select findGender('999999-4000000') from dual; --���� ���

/*
�ó�����] 
������̸�(first_name)�� �Ű������� ���޹޾Ƽ� �μ���(department_name)��
��ȯ�ϴ� �Լ��� �ۼ��Ͻÿ�.
�Լ��� : func_deptName
*/
--1�ܰ� : Nancy�� �μ����� ����ϱ� ���� inner join �ۼ�
select
    first_name, last_name, department_id, department_name
from employees inner join departments using(department_id)
where first_name='Nancy';

--2�ܰ� : �Լ� �ۼ�
create or replace function func_deptName (
    param_name varchar2 --����̸��� �ޱ� ���� �Ķ���� ����
)
return
    varchar2 --�μ����� ��ȯ�ϹǷ� ���������� ����
is
    --�μ����̺��� �μ����� �����ϴ� ��ȯ ������ ���� ����
    return_deptname departments.department_name%type;
begin
    --������ ���� �� ����� ������ �����Ѵ�.
    select
        department_name into return_deptname
    from employees inner join departments using(department_id)
    where first_name=param_name;
    --��� ��ȯ
    return return_deptname;
end;
/
select func_deptname('Nancy') from dual;--Finance ��ȯ
select func_deptname('Diana') from dual;--IT ��ȯ

/*
3.Ʈ����(Trigger)
    : �ڵ����� ����Ǵ� ���ν����� ���� ������ �Ұ����ϴ�.
    �ַ� ���̺� �Էµ� ���ڵ��� ��ȭ�� ������ ����ȴ�.
*/
--Ʈ���� �ǽ��� ���� HR�������� �Ʒ� ���̺��� �����Ѵ�.
create table trigger_dept_original
as
select * from departments;--���̺��� ���ڵ���� ��� ����
create table trigger_dept_backup
as
select * from departments where 1=0;--���̺��� ��Ű��(����)�� ���� 
    
/*
�ó�����] ���̺� ���ο� �����Ͱ� �ԷµǸ� �ش� �����͸�
������̺� �����ϴ� Ʈ���Ÿ� �ۼ��غ���.
*/
create trigger trig_dept_backup
    after /* Ÿ�̹� : after => �̺�Ʈ �߻� ��, before=>�̺�Ʈ�߻��� */
    INSERT /* �̺�Ʈ : �Է�/����/������ ���� ���� ����� �߻��� */
    on trigger_dept_original /* Ʈ���Ÿ� ������ ���̺� */
    for each row /*
        �� ���� Ʈ���ŷ� �����Ѵ�. �� �ϳ��� ���� ��ȭ�Ҷ����� Ʈ���Ű� ����ȴ�.
        ���� ����(���̺�)���� Ʈ���ŷ� �����ϰ� �ʹٸ� �ش� ������ �����ϸ�ȴ�.
        �̶��� ������ �ѹ� �����Ҷ� Ʈ���ŵ� �ѹ��� ����ȴ�.
    */
begin
    /* insert�̺�Ʈ�� �߻��Ǹ� true�� ��ȯ�Ͽ� if���� ����ȴ�. */
    if Inserting then
        dbms_output.put_line('insert Ʈ���� �߻���');
        /*
        ���ο� ���ڵ尡 �ԷµǾ����Ƿ� �ӽ����̺� :new�� ����ǰ�,
        �ش� ���ڵ带 ���� backup���̺� �Է��� �� �ִ�.
        �̿� ���� �ӽ����̺��� ����� Ʈ���ſ����� ����� �� �ִ�.
        */
        insert into trigger_dept_backup
        values (
            :new.department_id,
            :new.department_name,
            :new.manager_id,
            :new.location_id
        );
    end if;
end;
/
select * from trigger_dept_original;
select * from trigger_dept_backup;


insert into trigger_dept_original values (300, '�ڽ���112��', 10, 100);
insert into trigger_dept_original values (310, '�����ǹ�', 20, 120);

select * from trigger_dept_original order by department_id desc;
select * from trigger_dept_backup;

/*
�ó�����] �������̺��� ���ڵ尡 �����Ǹ� ������̺��� ���ڵ嵵 ����
�����Ǵ� Ʈ���Ÿ� �ۼ��غ���.
*/
create or replace trigger trig_dept_delete
    /* trigger_dept_original ���̺� ���ڵ带 ������ �� �������
    �ش� Ʈ���Ÿ� �����Ѵ�. */
    after
    delete
    on trigger_dept_original
    for each row
begin
    dbms_output.put_line('delete Ʈ���� �߻���');
    /*
    ���ڵ尡 ������ ���Ŀ� �̺�Ʈ�� �߻��Ǿ� Ʈ���Ű� ȣ��ǹǷ� :old
    �ӽ����̺��� ����Ѵ�.
    */
    if deleting then
        delete from trigger_d ept_backup
            where department_id = :old.department_id;
    end if;
end;
/
--300�� ���ڵ带 �����ϸ�...
delete from trigger_dept_original where department_id=300;
--��� ���̺��� 300���� ���� �����ȴ�.
select * from trigger_dept_original order by department_id desc;
select * from trigger_dept_backup;


/*
For each row �ɼǿ� ���� Ʈ���� ����Ƚ�� �׽�Ʈ

����1 : �������� ���̺� ������Ʈ ���� ������� �߻��Ǵ� Ʈ���� ����
*/
create trigger trigger_update_test
    after update 
    on trigger_dept_original 
    for each row 
    /* �������� ���̺��� ���ڵ带 ������Ʈ �� ���� ������� ����Ǵ� Ʈ���ŷ� 
    ������Ʈ �� ���� ������ŭ Ʈ���Ű� �߻��Ǿ� ������̺� insert �ȴ�.*/
begin
    if updating then
        dbms_output.put_line('update Ʈ���� �߻���');
        insert into trigger_dept_backup
        values (
            :old.department_id,
            :old.department_name,
            :old.manager_id,
            :old.location_id
        );
    end if;
end;
/
--���� ���ڵ� Ȯ���ϱ�
select * from trigger_dept_original order by department_id desc;
select * from trigger_dept_backup;

--������Ʈ����
update trigger_dept_original set department_name='5��������Ʈ'
where department_id>=10 and department_id<=50;

--�տ��� 5���� ���ڵ带 ������Ʈ �ϹǷ� ������̺��� 5���� �Էµȴ�.
select * from trigger_dept_original order by department_id asc;
select * from trigger_dept_backup;


--������� Ʈ���� �����ϱ�
drop trigger trigger_update_test;


/*
����2 : �������� ���̺� ������Ʈ ���� ���̺�(����) ������ �߻��Ǵ�
    Ʈ���� ����
*/
create trigger trigger_update_test2
    after update 
    on trigger_dept_original 
    /** for each row **/ 
    /* �������� ���̺��� ���ڵ带 ������Ʈ �� ���� ���̺������ Ʈ���Ű� ����ǹǷ� 
    ������ ���� ���� ������ ������� �ѹ��� Ʈ���Ű� ����ȴ�. */
begin
    if updating then
        dbms_output.put_line('update Ʈ���� �߻���');
        insert into trigger_dept_backup
        values (
            /** ���̺���� Ʈ���ſ����� �ӽ����̺��� ����� �� ����.
            :old.department_id,
            :old.department_name,
            :old.manager_id,
            :old.location_id
            **/
            999, to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'), 99, 99
        );
    end if;
end;
/

--������Ʈ����
update trigger_dept_original set department_name='5��������Ʈ2'
where department_id>=60 and department_id<=100;

--�տ��� 5���� ���ڵ带 ������Ʈ ������, ���̺���� Ʈ���Ŵ� 1���� �Էµȴ�.
select * from trigger_dept_original order by department_id asc;
select * from trigger_dept_backup;

--���̺���� Ʈ���� �����ϱ�
drop trigger trigger_update_test2;




