/*user table*/
create table users(
	id int primary key auto_increment,
    name varchar(100) not null,
    email varchar(100) not null unique,
    password varchar(255) not null,
    role ENUM('user','employer','admin') not null default 'user',
    status ENUM('active','blocked') default 'active',
    created_at timestamp default current_timestamp
);
  
/*jobs table*/
create table jobs(
	id int primary key auto_increment,
    title varchar(150) not null,
    description text not null,
    skills text not null,
    company varchar(100) not null,
    location varchar(100),
    experience varchar(50),
    package_lpa varchar(50),
    vacancies int,
    employer_id int,
    created_at timestamp default current_timestamp,
    status varchar(10) not null default 'active',
    foreign key(employer_id) references users(id)
);

/*applications table*/
create table applications(
	id int primary key auto_increment,
    user_id int not null,
    job_id int not null,
    resume_path varchar(255),
    score float,
    status enum('applied','shortlisted','rejected') default 'applied',
    applied_at timestamp default current_timestamp,
    foreign key(user_id) references users(id),
    foreign key(job_id) references jobs(id)
);

/*resume_analysis_logs table*/
create table resume_analysis_logs (
	id int primary key auto_increment,
    user_id int not null,
    result_json json not null,
    foreign key(user_id) references users(id)
);
alter table resume_analysis_logs add created_at timestamp default current_timestamp;