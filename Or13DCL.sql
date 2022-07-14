/*******************************
���ϸ� : Or13DCL.sql
DCL : Data Control Language(������ �����)
����ڱ���
���� : ���ο� ����ڰ����� �����ϰ� �ý��۱����� �ο��ϴ� ����� �н�
*******************************/

/*
[����ڰ��� ���� �� ���Ѽ���]
�ش� ������ DBA������ �ִ� �ְ������(sys, system)�� ������ ��
�����ؾ� �Ѵ�. 
����� ���� ������ ���� �׽�Ʈ�� CMD(���������Ʈ)���� �����Ѵ�. 
*/


/*
1]����� ���� ���� �� ��ȣ����
����]
    create user ���̵� identified by �н�����;
*/
create user test_user1 identified by 1234;
--#������ ������ ���� cmd���� sqlplus������� ���ӽ� login denied �����߻���
--#��, ���ӱ����� ���� ������ ���� �ʴ´�. 


/*
2]������ ����� ������ ���� Ȥ�� ���� �ο�
����]
    grant �ý��۱���1, 2, ... N
        to ����ڰ�����
            [with grant �ɼ�];
*/
--���ӱ��� �ο� : create session�� test_user1�� �ο��Ѵ�. 
grant create session to test_user1 ;
--���� �ο��� ������ �����ߴ�. ������ ���̺������ �ȵȴ�. 

--���̺� ���� ���� �ο�
grant create table to test_user1;
--#���̺� ������ ���̺� �����̽��� ���� ���� �߻���

/*
���̺� �����̽���?
    ��ũ ������ �Һ��ϴ� ���̺�� ��, �׸��� �� ���� �ٸ� �����ͺ��̽�
    ��ü���� ����Ǵ� ����̴�. ���� ��� ����Ŭ�� ���ʷ� ��ġ�ϸ�
    hr������ �����͸� �����ϴ� user��� ���̺� �����̽��� �ڵ����� �����ȴ�. 
*/
--���̺� �����̽� ��ȸ�ϱ�
desc dba_tablespaces;
select tablespace_name, status, contents from dba_tablespaces;

--���̺� �����̽��� ��� ������ ���� Ȯ���ϱ�
select 
    tablespace_name, sum(bytes), max(bytes),
    to_char(sum(bytes), '9,999,999,000'),
    to_char(max(bytes), '9,999,999,000')
from dba_free_space
group by tablespace_name;

--�տ��� ������ test_user1 ������� ���̺����̽� Ȯ���ϱ�
select username, default_tablespace from dba_users
where username in upper('test_user1');--system ���̺� �����̽� ���� Ȯ��

--���̺� �����̽� ���� �Ҵ�
alter user test_user1 quota 2m on system;
/*
    test_user1�� system ���̺� �����̽��� ���̺��� ������ �� �ֵ���
    2m�� �뷮�� �Ҵ��Ѵ�. 
*/
--cmd ���� ���̺� ������ �Ǵ��� Ȯ���غ���.(������)


--2��° ����� �߰� : ���̺� �����̽��� users�� �����Ͽ� �����Ѵ�. 
create user test_user2 identified by 1234 default tablespace users;
grant create session to test_user2;--���� ���� �ο�
grant create table to test_user2;--���̺���� ���� �ο�
/*# ���̺��� �����ϸ� users ���̺����̽��� ���� ������ ���� �������� �ʴ´�. */

--�տ��� �����ѵ��� ���̺����̽� users�� ����ϰ� �ִ�. 
select username, default_tablespace from dba_users
where username in upper('test_user2');
--users ���̺����̽��� 10m�� ������ �Ҵ��Ѵ�. 
alter user test_user2 quota 10m on users;
/*# ���̺��� ���������� �����ȴ�. */

/*
�̹� ������ ������� ����Ʈ ���̺����̽��� �����ϰ� �������� 
alter user����� ����Ѵ�. 
*/
select username, default_tablespace from dba_users
where username in upper('test_user1');--���̺����̽� system Ȯ��

alter user test_user1 default tablespace users;--users�� ����

select username, default_tablespace from dba_users
where username in upper('test_user1');--users�� Ȯ�ε�
/*
    cmd���� test_user1�� ������ �� ���̺��� �����ϸ� ������ �߻��Ѵ�. 
    �տ��� �ο��� ���̺� �����̽� ������ system���� �Ҵ�Ǿ����Ƿ� 
    users�� ������ �ο��� �� ���̺��� �����ؾ� �Ѵ�.(�������� ���� �غ�����) 
*/

/*
3]��ȣ����
    alter user ����ڰ��� identified by �����Һ��;
*/
alter user test_user1 identified by 4321;
/*# ��ȣ�� ����Ǿ����Ƿ� cmd���� 1234�� ���ӵ��� �ʴ´�. */




/*
4] Role(��)�� ���� �������� ������ ���ÿ� �ο��ϱ�
    : ���� ����ڰ� �پ��� ������ ȿ�������� ������ �� �ֵ���
    ���õ� ���ѳ��� ����������� ���Ѵ�. 
�ؿ츮�� �ǽ��� ���� ���Ӱ� ������ ������ connect, resource���� �ַ� �ο��Ѵ�.   
*/
grant connect, resource to test_user2;
/*
    # test_user1�� ��� ���ӱ���, ���̺�������Ѹ� �ο������Ƿ� ��������
    ������ �� ����. 
    # test_user2�� Role(��)�� ���� ������ �ο��ϹǷ� ������ ������ �����ϴ�. 
*/

/*
4-1] �� �����ϱ� : ����ڰ� ���ϴ� ������ ���� ���ο� ���� �����Ѵ�. 
*/
create role kosmo_role;

/*
4-2] ������ �ѿ� ���� �ο��ϱ�
*/
grant create session, create table, create view to kosmo_role;
--���ο� ����� ���� ������ �� ���� ���� ���Ѻο�
create user test_user3 identified by 1234;
grant kosmo_role to test_user3;
/*# ������ ������ ���̺� �����̽��� ���� ���̺������ �ȵȴ�. */

/*
4-3] �� �����ϱ�
*/
drop role kosmo_role;
/*
    #test_user3 ����ڴ� kosmo_role�� ���� ������ �ο��޾����Ƿ�
    �ش� ���� �����ϸ� �ο��޾Ҵ� ��� ������ ȸ��(revoke)�ȴ�. 
    ��, �� �����Ŀ��� ������ �� ����. 
*/
--# test_user3�� ���� �Ұ�..

/*
5] ��������(ȸ��)
    ����] revoke ���� �� ���� from ����ڰ���;
*/
revoke create session from test_user1;
--# test_user1�� ���� �Ұ�..

/*
6] ����� ���� ����
    ����] drop user ����ڰ��� [cascade];
��cascade�� ����ϸ� ����ڰ����� ���õ� ��� �����ͺ��̽� ��Ű���� 
�����ͻ������� ���� �����ǰ� ��� ��Ű�� ��ü�� ���������� �����ȴ�. 
*/
--���� ������ ����� ����� Ȯ���� �� �ִ� �����ͻ���
select * from dba_users;
--������ �����ϸ鼭 ��� �������� ��Ű������ ���� �����Ѵ�. 
drop user test_user1 cascade;










