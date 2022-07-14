/*
���ϸ� : Or11Constraint.sql
��������
���� : ���̺� ������ �ʿ��� �������� �������ǿ� ���� �н��Ѵ�.
*/
--study �������� �ǽ��մϴ�. 

/*
primary key : �⺻Ű
-�������Ἲ�� �����ϱ� ���� ������������
-�ϳ��� ���̺� �ϳ��� �⺻Ű�� ������ �� �ִ�. 
-�⺻Ű�� ������ �÷��� �ߺ��Ȱ��̳� Null���� �Է��� �� ����. 
-�ַ� ���ڵ� �ϳ��� Ư���ϱ� ���� ���ȴ�. 
*/

/*
����1] �ζ��� ��� : �÷� ������ ������ ���������� �����
    create table ���̺�� (
        �÷��� �ڷ���(ũ��) [constraint PK�����] primary key
    );
    []���ȣ �κ��� ���� �����ϰ�, ������ ������� �ý����� �ڵ����� �ο��Ѵ�. 
*/
create table tb_primary1 (
    idx number(10) primary key,
    user_id varchar2(30),
    user_name varchar2(50)
);
desc tb_primary1;

/*
�������� �� ���̺��� Ȯ���ϱ�
    tab : ���� ������ ������ ���̺��� ����� Ȯ���� �� �ִ�. 
    user_cons_columns : ���̺� ������ �������Ǹ�� �÷����� ������ 
        ������ �����Ѵ�. 
    user_constraints : ���̺� ������ ���������� ���� ���� ������ 
        �����Ѵ�. 
�� �̿Ͱ��� ���������̳� ��, ���ν������� ������ �����ϰ� �ִ�
    �ý��� ���̺��� "�����ͻ���"�̶�� �Ѵ�.   
*/
select * from tab;
select * from user_cons_columns;
select * from user_constraints;

--���ڵ� �Է�
insert into tb_primary1 (idx, user_id, user_name) values (1, 'kosmo', '�ڽ���');
insert into tb_primary1 (idx, user_id, user_name) values (1, 'smo', '����');/*
        ���Ἲ �������� ����� ������ �߻��Ѵ�. PK�� ������ �÷� idx����
        �ߺ��� ���� �Է��� �� ����. 
    */
insert into tb_primary1 values (2, 'white', 'ȭ��Ʈ');
insert into tb_primary1 values ('', 'black', '��');/*
        PK�� ������ �÷����� null���� �Է��� �� ����. 
    */
select * from tb_primary1;
update tb_primary1 set idx=2 where user_name='�ڽ���';/*
        update���� ���������� idx���� �̹� �����ϴ� 2�� ���������Ƿ�
        �������� ����� �����߻���
    */


/*
����2] �ƿ����� ���
    create table ���̺�� (
        �÷��� �ڷ���, 
        [constraint �����] primary key (�÷���)
    );  
*/
create table tb_primary2 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50),
    
    constraint my_pk1 primary key (user_id)
);
desc tb_primary2;
select * from user_constraints;

insert into tb_primary2 values (1, 'white', 'ȭ��Ʈ1');
insert into tb_primary2 values (2, 'white', 'ȭ��Ʈ2');/*
        user_id�� �ߺ��� ���� �ԷµǾ����Ƿ� ���� �߻���. 
        �̶� �α׿��� �츮�� �ο��� PK���� 'my_pk1'�� ��µȴ�. 
    */

/*
����3] ���̺� ������ alter������ �������� �߰�
    alter table ���̺�� add [constraint �����] primary key (�÷���);
*/
create table tb_primary3 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50)
);
--���̺��� ������ �� alter����� ���� ���������� �ο��� �� �ִ�. 
--������� ��� ������ �����ϴ�. 
alter table tb_primary3 add constraint tb_primary3_pk 
    primary key (user_name);
select * from user_constraints;
--���������� ���̺��� ������� �ϹǷ� ���̺��� �����Ǹ� �������ǵ� ���� �����ȴ�. 
drop table tb_primary3;
select * from user_constraints;
--PK�� �ϳ��� ������ �� �ִ�. 
create table tb_primary3 (
    idx number(10) primary key,
    user_id varchar2(30) primary key,
    user_name varchar2(50)
);--�����߻�


/*
unique : ����ũ
-���� �ߺ��� ������� �ʴ� ������������
-����, ���ڴ� �ߺ��� ������� �ʴ´�. 
-������ null���� ���ؼ��� �ߺ��� ����Ѵ�. 
-unique�� �� ���̺� 2���̻� ������ �� �ִ�. 
*/
create table tb_unique (
    idx number unique not null, /*idx�÷� �ܵ����� unique�� ������*/
    name varchar2(30),
    telephone varchar2(20),
    nickname varchar2(30),
    /* 2���� �÷��� ���ļ� ������. ���� �������Ǹ����� unique�� �����ȴ�. */
    unique(telephone, nickname)
);
--�����ͻ������� �������� Ȯ��
select * from user_cons_columns;
select * from user_constraints;
--���ڵ� �Է�
insert into tb_unique (idx, name, telephone, nickname)
    values (1, '���̸�', '010-1111-1111', '���座��');
insert into tb_unique (idx, name, telephone, nickname)
    values (2, '����', '010-2222-2222', '');
insert into tb_unique (idx, name, telephone, nickname)
    values (3, '����', '', ''); --unique�� null���� ������ �Է��� �� ����.
select * from tb_unique;    

insert into tb_unique (idx, name, telephone, nickname)
    values (1, '����', '010-3333-3333', '');--�����߻�. �ߺ��� idx�� ������.

insert into tb_unique values (4, '���켺', '010-4444-4444', '��ȭ���');
insert into tb_unique values (5, '������', '010-5555-5555', '��ȭ���');--�Է¼���
insert into tb_unique values (6, 'Ȳ����', '010-4444-4444', '��ȭ���');--�Է½���
/*
    telephone�� nickname �÷��� ������ ��������� �����Ǿ����Ƿ� 
    �ΰ��� �÷��� ���ÿ� ������ ���� ������ ��찡 �ƴ϶�� �ߺ��� ����
    ���ȴ�.
    ��, 4���� 5���� ���� �ٸ� �����ͷ� �ν��ϹǷ� �Էµǰ�, 
    4���� 6���� ������ �����ͷ� �νĵǾ� ������ �߻��Ѵ�.
*/


/*
Foreign key : �ܷ�Ű, ����Ű
-�ܷ�Ű�� �������Ἲ�� �����ϱ� ���� ������������
-���� ���̺��� �ܷ�Ű�� �����Ǿ� �ִٸ� �ڽ����̺� ��������
    ������ ��� �θ����̺��� ���ڵ�� ������ �� ����. 

����1] �ζ��ι��
    create table ���̺�� (
        �÷��� �ڷ��� [constraint �����] 
            references �θ����̺�� (������ �÷���)                    
    );    
*/
create table tb_foreign1(
    f_idx number(10) primary key,
    f_name varchar2(50),
    /*
    �ڽ����̺��� tb_foreign1���� �θ����̺��� tb_primary2�� 
    user_id�� �����ϴ� �ܷ�Ű�� �����Ѵ�. 
    */
    f_id varchar2(30) constraint tb_foreign_fk1
        references tb_primary2(user_id)
);
select * from tb_primary2;--���ڵ�1�� ����
select * from tb_foreign1;--���ڵ尡 ����
--�����߻�. �θ����̺� gildong�̶�� ���̵� ����. 
insert into tb_foreign1 values (1, 'ȫ�浿', 'gildong');
--����. �θ����̺� white��� ���̵� �ԷµǾ� ����.
insert into tb_foreign1 values (1, '�Ͼ��', 'white');
/*
�ڽ����̺��� �����ϴ� ���ڵ尡 �����Ƿ�, �θ����̺��� ���ڵ带
������ �� ����. �̰�� �ݵ�� �ڽ����̺��� ���ڵ带 ���� ������ ��
�θ����̺��� ���ڵ带 �����ؾ� �Ѵ�. 
*/
delete from tb_primary2 where user_id='white';--�����߻�

--�ڽ� ���ڵ带 ���� ������ �� ...
delete from tb_foreign1 where f_id='white';
--�θ� ���ڵ带 ������ �� �ִ�. 
delete from tb_primary2 where user_id='white';

select * from tb_primary2;
select * from tb_foreign1;
/*
    2���� ���̺��� �ܷ�Ű(����Ű)�� �����Ǿ��ִ� ���
    �θ����̺� ������ ���ڵ尡 ������ �ڽ����̺� insert�Ҽ� ����. 
    �ڽ����̺� �θ� �����ϴ� ���ڵ尡 ���������� �θ����̺��� ���ڵ带
    delete �� �� ����. 
*/

/*
����2] �ƿ����ι��
    create table ���̺�� (
        �÷��� �ڷ��� ,         
        [constraint �����] foreign key (�÷���)
            references �θ����̺� (�������÷�)
    )
*/
create table tb_foreign2 (
    f_id number primary key,
    f_name varchar2(30),
    f_date date,
    /*  
    tb_foreign2���̺��� f_id�÷��� �θ����̺��� tb_primary1�� idx�÷���
    �����ϴ� �ܷ�Ű�� ������
    */
    foreign key (f_id) references tb_primary1(idx)
);
select * from user_constraints;
/*
������ �������� �������� Ȯ�ν��� �÷���
P : Primary key
R : Reference integrity �� Foreign key�� ����
C : Check Ȥ�� Not null
U : Unique
*/

/*
����3] ���̺� ������ alter������ �ܷ�Ű �������� �߰�
    alter table ���̺�� add [constraint �����]
        foriegn key (�÷���)
            references �θ����̺�(�����÷���);
*/
create table tb_foreign3 (
    idx number primary key,
    f_name varchar2(30),
    f_idx number(10)
);
alter table tb_foreign3 add
    foreign key (f_idx) references tb_primary1 (idx);
/*
    �ϳ��� �θ����̺� �� �̻��� �ڽ����̺��� �ܷ�Ű�� ������ �� �ִ�.
*/



/*
�ܷ�Ű ������ �ɼ�
[on delete cascade] 
    : �θ��ڵ� ������ �ڽķ��ڵ���� ���� ������
    ����]
        �÷��� �ڷ��� references �θ����̺�(pk�÷�)
            on delete cascade;
[on delete set null]
    : �θ��ڵ� ������ �ڽķ��ڵ� ���� null�� �����
    ����]  
        �÷��� �ڷ��� references �θ����̺�(pk�÷�)
            on delete set null
�� �ǹ����� ���԰Խù��� ���� ȸ���� �� �Խñ��� �ϰ������� �����ؾ��Ҷ�
����� �� �ִ� �ɼ��̴�. ��, �ڽ����̺��� ��� ���ڵ尡 �����ǹǷ� ��뿡
�����ؾ��Ѵ�. 
*/
create table tb_primary4(
    user_id varchar2(30) primary key,
    user_name varchar2(100)
);
create table tb_foreign4(
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraint tb_foreign4_fk
        references tb_primary4 (user_id)
            on delete cascade
);
drop table tb_foreign4;

--�ܷ�Ű�� ������ ��� �ݵ�� �θ����̺� ���� ���ڵ带 �Է��ؾ� �Ѵ�. 
insert into tb_primary4 values ('kosmo', '�ڽ���');
insert into tb_foreign4 values (1, '����1�Դϴ�.', 'kosmo');
insert into tb_foreign4 values (2, '����2�Դϴ�.', 'kosmo');
insert into tb_foreign4 values (3, '����3�Դϴ�.', 'kosmo');
insert into tb_foreign4 values (4, '����4�Դϴ�.', 'kosmo');
insert into tb_foreign4 values (5, '����5�Դϴ�.', 'kosmo');
insert into tb_foreign4 values (6, '����6�Դϴ�.', 'kosmo');
insert into tb_foreign4 values (7, '����7�Դϴ�.', 'kosmo');
insert into tb_foreign4 values (8, '��..����..??', 'gasan');--�θ�Ű�� �����Ƿ� �����߻�

select * from tb_primary4;--���ڵ� 1�� ����
select * from tb_foreign4;--���ڵ� 7�� ����

/*
�θ����̺��� ���ڵ带 ������ ��� on delete cascade �ɼǿ� ����
�ڽ��ʱ��� ��� ���ڵ尡 �����ȴ�. �ش� �ɼ��� ���ٸ� �������� �ʴ´�. 
*/
delete from tb_primary4 where user_id='kosmo';

select * from tb_primary4;
select * from tb_foreign4;--��� ���ڵ� ������


--on delete set null �ɼ� �׽�Ʈ
create table tb_primary5(
    user_id varchar2(30) primary key,
    user_name varchar2(100)
);
create table tb_foreign5(
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraint tb_foreign5_fk
        references tb_primary5 (user_id)
            on delete set null
);
insert into tb_primary5 values ('kosmo', '�ڽ���');
insert into tb_foreign5 values (1, '����1�Դϴ�.', 'kosmo');
insert into tb_foreign5 values (2, '����2�Դϴ�.', 'kosmo');
insert into tb_foreign5 values (3, '����3�Դϴ�.', 'kosmo');
insert into tb_foreign5 values (4, '����4�Դϴ�.', 'kosmo');
insert into tb_foreign5 values (5, '����5�Դϴ�.', 'kosmo');
insert into tb_foreign5 values (6, '����6�Դϴ�.', 'kosmo');
insert into tb_foreign5 values (7, '����7�Դϴ�.', 'kosmo');

select * from tb_primary5;
select * from tb_foreign5;
/*
on delete set null �ɼ����� �ڽ����̺��� ���ڵ�� ���������� �ʰ�, 
����Ű �κи� null������ ����Ǿ�, ���̻� ������ �� ���� ���ڵ�� ����ȴ�. 
*/
delete from tb_primary5 where user_id='kosmo';

select * from tb_primary5;--�θ����̺��� ���ڵ�� ������
select * from tb_foreign5;--�ڽ����̺��� ���ڵ�� ��������. �� null�� �����.


/*
not null : null���� ������� �ʴ� ��������
    ����]
        create table ���̺�� (
            �÷��� �ڷ��� not null,
            �÷��� �ڷ��� null <- null�� ����Ѵٴ� �ǹ̷� �ۼ������� 
                                �̷��� ������� �ʴ´�. null�� ������� 
                                ������ �ڵ����� ����Ѵٴ� �ǹ̰� �ȴ�. 
        );
*/
create table tb_not_null (
    m_idx number(10) primary key, /* PK�̹Ƿ� NN */
    m_id varchar2(20) not null,   /* NN */
    m_pw varchar2(30) null,       /* null���(�Ϲ������� �̷��� ���� �ʴ´�) */
    m_name varchar2(40)           /* null���(�̿Ͱ��� �����Ѵ�) */
);
desc tb_not_null;

insert into tb_not_null values (10, 'hong1', '1111', 'ȫ�浿');
insert into tb_not_null values (20, 'hong2', '1111', '');
insert into tb_not_null values (30, 'hong3', '', '');
insert into tb_not_null values (40, '', '', '');--�����߻�. m_id�� NN�� ������.
--�����߻�. PK���� null���� �Է��� �� ����. 
insert into tb_not_null (m_id, m_pw, m_name) values ('hong5', '5555', '���浿');
--�Է¼���. space�� �����̹Ƿ� �Էµȴ�. 
insert into tb_not_null values (60, ' ', '6666', '���浿');

select * from tb_not_null;

/*
default : insert �� �ƹ��� ���� �Է����� �ʾ����� �ڵ����� ���ԵǴ�
    �����͸� �����Ѵ�. 
*/
create table tb_default (
    id varchar2(30) not null,
    pw varchar2(50) default 'qwer'
);
insert into tb_default values ('aaaa', '1234'); --1234�Էµ�
insert into tb_default (id) values ('bbbb');    --�÷���ü�� �����Ƿ� default�� �Է�
insert into tb_default values ('cccc', '');     --null���� �Է�
insert into tb_default values ('dddd', ' ');    --����(space)�Է�
insert into tb_default values ('eeee', default);--default�� �Է�
/*
    default���� �Է��Ϸ��� insert������ �÷� ��ü�� ���ܽ�Ű�ų�
    default Ű���带 ����ؾ� �Ѵ�. 
*/
select * from tb_default;


/*
check : Domain(�ڷ���) ���Ἲ�� �����ϱ� ���� ������������ 
    �ش� �÷��� �߸��� �����Ͱ� �Էµ��� �ʵ��� �����ϴ� ���������̴�. 
*/
create table tb_check1(
    gender char(1) not null
        constraint check_gender
            /* M, F�� �Է��� ����Ѵ�. */
            check (gender in ('M', 'F'))
);
insert into tb_check1 values ('M');
insert into tb_check1 values ('F');
insert into tb_check1 values ('A');--�Է½���
insert into tb_check1 values ('����');--�Է½���

create table tb_check2 (
    sale_count number not null
        /* �ش� �÷��� 10������ ���� ����Ѵ�. */
        check (sale_count<=10)
);
insert into tb_check2 values (9);
insert into tb_check2 values (10);
insert into tb_check2 values (11);--�Է½���





