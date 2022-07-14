/************************
���ϸ� : Or03String.sql
���ڿ� ó���Լ�
���� : ���ڿ��� ���� ��ҹ��ڸ� ��ȯ�ϰų� ���ڿ��� ���̸� ��ȯ�ϴ� �� ���ڿ���
    �����ϴ� �Լ�
*************************/

/*
concat(���ڿ�1, ���ڿ�2)
    : ���ڿ� 1�� 2�� ���� �����ؼ� ����ϴ� �Լ�
    ����1 : concat('���ڿ�1', '���ڿ�2')
    ����2 : '���ڿ�1' || '���ڿ�2'
*/
select concat('Good ', 'morning') as "��ħ�λ�" from dual;
select 'Oracle'||' 11g'||' Good' from dual;
-- => �� SQl���� concat()���� �����ϸ� ������ ����.
    select concat(concat('Oracle', ' 11g'),' Good') from dual;


/*
�ó�����] ������̺��� ����� �̸��� �����ؼ� �Ʒ��� ���� ����Ͻÿ�.
    ��³��� : first+last name, �޿�, �μ���ȣ
*/
--step1 : �̸��� ���������� ���Ⱑ �ȵż� �������� ������
select 
    concat(first_name, last_name), salary, department_id
from employees;
--step2 : �����̽��� �߰��ϱ� ���� concat()�� �ϳ� �� �����
select 
    concat(concat(first_name, ' '), last_name), salary, department_id
from employees;
--step3 : 2���� �Լ��� ����ϴ°ͺ��ٴ� ||�� �̿��ϸ� ������ ǥ���� �� ����
--          ���� �÷����� as�� �̿��ؼ� ��Ī�� �ο���
select 
    first_name||' '||last_name as fullname, salary, department_id
from employees;

/*
initcap(���ڿ�)
    : ���ڿ��� ù���ڸ� �빮�ڷ� ��ȯ�ϴ� �Լ�.
    ��, ù���ڸ� �ν��ϴ� ������ ������ ����.
    -���鹮�� ������ ������ ù���ڸ� �빮�ڸ� ��ȯ�Ѵ�.
    -���ĺ��� ���ڸ� ������ ������ ���� ������ ������ ù��° ���ڸ� �빮�ڷ� ��ȯ�Ѵ�.
*/
select initcap('hi hello �ȳ�') from dual;--hi, hello�� ù���ڸ� �빮�ڷ� ����
select initcap('good/bad morning') from dual;--g, b, m�� �빮�ڷ� ����
select initcap('never6say*good��bye') from dual;--n, g, b�� �빮�ڷ� ����
/*
�ó�����] ������̺��� first_name�� john�� ����� ã�� �����Ͻÿ�.
*/
select * from employees where first_name='john';--�������(�����ʹ� ��ҹ��� ������)
--�Ʒ� �������� �˻������ 3�� ���´�.
select * from employees where first_name=initcap('john');--John���� �˻�
select * from employees where first_name='John';

/*
��ҹ��� �����ϱ�
lower() : �ҹ��ڷ� ������
upper() : �빮�ڷ� ������
*/
select lower('GOOD'), upper('bad') from dual;
--���Ͱ��� john�� �˻��ϱ� ���� ������ ���� ����� �����ִ�.
select * from employees where lower(first_name)= 'john';
select * from employees where upper(first_name)= 'JOHN';
select 
    first_name, last_name, lower(first_name), upper(last_name)
from employees where upper(first_name)= 'JOHN';

/*
lpad(), rpad()
    : ���ڿ��� ����, �������� Ư���� ��ȣ�� ä�ﶧ ����Ѵ�.
    ����] lpad('���ڿ�', '��ü�ڸ���', 'ä�﹮�ڿ�')
        -> ��ü�ڸ������� ���ڿ��� ���̸�ŭ�� ������ ������
        �����κ��� �־��� ���ڿ��� ä���ִ� �Լ�.
        rpad()�� �������� ä����.
*/
select
    'good',
    lpad('good', 7, '#'), rpad('good', 7, '#'), lpad('good',7)
from dual;
--�÷��� �����ϸ� ������ ���� �� �� �ִ�. �̸��� �����κ��� *�� ä���.
select rpad(first_name, 10, '*') from employees;

/*
trim() : ������ �����Ҷ� ����Ѵ�.
    ����] trim([leading | trailing | both] ������ ���� from �÷�)
        - leading : ���ʿ��� ������
        - trailing : �����ʿ��� ������
        - both : ���ʿ��� ������. �������� ������ both�� ����Ʈ��.
        [����1] ���ʳ��� ���ڸ� ���ŵǰ�, �߰��� �ִ� ���ڴ� ���ŵ��� ����.
        [����2] '����'�� �����Ҽ��ְ�, '���ڿ�'�� �����Ҽ� ����. �����߻���
*/
--as(��Ī)�� ���� ������
--both�� ����Ʈ �ɼ��̹Ƿ� trim3, trim4�� ����� ������.
select
    ' ���������׽�Ʈ ' as trim1,
    trim(' ���������׽�Ʈ ') as trim2, /* ������ ���� ���ŵ� */
    trim('��' from '�ٶ��㰡 ������ ž�ϴ�') trim3, /* ������ ���� '��' ���� */
    trim(both '��' from '�ٶ��㰡 ������ ž�ϴ�') trim4, /*both�� ����Ʈ �ɼ���*/
    trim(leading '��' from '�ٶ��㰡 ������ ž�ϴ�') trim5, /*������ '��' ����*/
    trim(trailing '��' from '�ٶ��㰡 ������ ž�ϴ�') trim6, /*������ '��' ����*/
    trim('��' from '�ٶ��㰡 �ٸ����� ������ ž�ϴ�') trim7
from dual;
--trim�� �߰��� ���ڴ� ������ �� ����. ���� ���� ���ڸ� ���ŵȴ�.

--trim�� ���ڸ� ������ �� �ְ�, ���ڿ��� ������ �� ����. �Ʒ������� �����߻���.
select
    trim('�ٶ���' from '�ٶ��㰡 ������ Ÿ�ٰ� ���������ϴ٤̤�') as trimError
from dual;

/*
ltrim(), rtrim() : L[eft]TRIM, R[ight]TRIM
    : ����, ���� '����' Ȥ�� '���ڿ�'�� �����Ҷ� ����Ѵ�.
    �� TRIM�� ���ڿ��� ������ �� ������, LTRIM�� RTRIM�� ���ڿ�����
    ������ �� �ִ�.
*/
select
    ltrim(' ������������ ') ltrim1,
    /*�Ʒ��� ��� ������ �����̽��� ���Ե� ���ڿ��̹Ƿ� �������� �ʴ´�.*/
    ltrim(' ������������ ', '����') ltrim2,
    /*���⼭�� ���ڿ��� �����ȴ�.*/
    ltrim('������������ ', '����') ltrim3,
    rtrim('������������', '����') rtrim4,
    /*���ڿ� �߰��� ���ŵ��� �ʴ´�.*/
    rtrim('������������', '����') rtrim5
from dual;

/*
substr() : ���ڿ����� �����ε������� ���̸�ŭ �߶� ���ڿ��� ����Ѵ�.
    ����] substr(�÷�, �����ε���, ����)
    
    ����1) ����Ŭ�� �ε����� 1���� �����Ѵ�. (0���� �ƴ�)
    ����2) '����'�� �ش��ϴ� ���ڰ� ������ ���ڿ��� �������� �ǹ��Ѵ�.
    ����3) �����ε����� ������ ���������� �·� �ε����� �����Ѵ�.
*/
select substr('good morning john', 8, 4) from dual;--rnin
select substr('good morning john', 8) from dual;--r���� ������ ��µȴ�.

/*
�ó�����]] ������̺��� first_name�� ���� 4���ڸ� ����ϰ�, ���� �κ���
    *�� ä��� �������� �ۼ��Ͻÿ�.
*/
select rpad(substr(first_name, 1, 4), 7, '*')
from employees;

/*
replace() : ���ڿ��� �ٸ� ���ڿ��� ��ü�Ҷ� ����Ѵ�.
    ���� �������� ���ڿ��� ��ü�Ѵٸ� ���ڿ��� �����Ǵ� ����� �ȴ�.
    ����] replace(�÷��� or ���ڿ�, '������ ����� ����', '������ ����')
    
     ��trim(), ltrim(), rtrim()�޼ҵ��� ����� replace()�޼ҵ� �ϳ��� ��ü�Ҽ�
     �����Ƿ� trim()�� ���� replace()�� �ξ� �� ���󵵰� ����.
*/
--���ڿ� ����
select replace('good morning john', 'morning', 'evening') from dual;
--���ڿ� ���� : ���ڿ��� ����ǹǷ� ������� �Ҽ��ִ�.
select replace('good morning john', 'john', '') from dual;
--trim�� ��� �¿����� ���鸸 ���ŵȴ�.
select trim(' ����1 ����2 ') from dual;
--replace�� �¿����� �ƴ϶� �߰��� ���鵵 ������ �� �ִ�.
select replace(' ����1 ����2 ', ' ', '') from dual;

--102�� ����� ���ڵ带 ������� ��� ���ڿ� ���� ����� �����غ���.
select 
    first_name, last_name,
    ltrim(first_name, 'L') "����L����",
    rtrim(first_name, 'ex') "����ex����",
    replace(last_name, ' ', '') "�߰���������",
    replace(last_name, 'De', 'Dae') "�̸�����"
from employees where employee_id=102;

/*
instr() : �ش� ���ڿ����� Ư�����ڰ� ��ġ�� �ε������� ��ȯ�Ѵ�.
    ����1] instr(�÷���, 'ã������')
        => ���ڿ��� ó������ ���ڸ� ã�´�.
    ����2] instr(�÷���, 'ã������', 'Ž���� ������ �ε���', '���°����')
        => Ž���� �ε������� ���ڸ� ã�´�. ��, ã�� ������ ���°��
        �ִ� �������� ������ �� �ִ�.
*/
--n�� �߰ߵ� ù��° �ε��� ��ȯ
select instr('good morning tom', 'n') from dual;
--�ε���1���� Ž���� �����ؼ� n�� �߰ߵ� �ι�° �ε��� ��ȯ
select instr('good morning tom', 'n', 1, 2) from dual;
--�ε���8���� Ž���� �����ؼ� m�� �߰ߵ� ù��° �ε��� ��ȯ
select instr('good morning tom', 'm', 8, 1) from dual;





















