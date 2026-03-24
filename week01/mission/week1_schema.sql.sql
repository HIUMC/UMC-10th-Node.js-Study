CREATE DATABASE IF NOT EXISTS umc_db_week1;
USE umc_db_week1;

create table food_category
(
    id   bigint auto_increment
        primary key,
    name varchar(50) not null,
    constraint name
        unique (name)
);

create table region
(
    id   bigint auto_increment
        primary key,
    name varchar(50) not null,
    constraint name
        unique (name)
);

create table store
(
    id               bigint auto_increment
        primary key,
    region_id        bigint                                                       not null,
    food_category_id bigint                                                       not null,
    name             varchar(100)                                                 not null,
    address          varchar(300)                                                 not null,
    score            float                              default 0                 not null,
    status           enum ('OPEN', 'CLOSED', 'DELETED') default 'OPEN'            null,
    created_at       datetime                           default CURRENT_TIMESTAMP not null,
    updated_at       datetime                           default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint store_ibfk_1
        foreign key (region_id) references region (id),
    constraint store_ibfk_2
        foreign key (food_category_id) references food_category (id)
);

create table mission
(
    id           bigint auto_increment
        primary key,
    store_id     bigint                             not null,
    title        varchar(200)                       not null,
    introduction text                               null,
    point_reward int      default 0                 not null,
    deadline     date                               null,
    created_at   datetime default CURRENT_TIMESTAMP not null,
    updated_at   datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint mission_ibfk_1
        foreign key (store_id) references store (id)
            on delete cascade
);

create index store_id
    on mission (store_id);

create index food_category_id
    on store (food_category_id);

create index region_id
    on store (region_id);

create table terms
(
    id          bigint auto_increment
        primary key,
    title       varchar(100)                         not null,
    content     text                                 not null,
    is_required tinyint(1) default 1                 not null,
    created_at  datetime   default CURRENT_TIMESTAMP not null
);

create table user
(
    id          bigint auto_increment
        primary key,
    email       varchar(100)                                                    not null,
    password    varchar(200)                                                    not null,
    nickname    varchar(20)                                                     not null,
    name        varchar(20)                                                     not null,
    phone       varchar(20)                                                     null,
    gender      enum ('MALE', 'FEMALE', 'NONE')       default 'NONE'            null,
    birth_date  date                                                            null,
    profile_img varchar(500)                                                    null,
    point       int                                   default 0                 not null,
    status      enum ('ACTIVE', 'INACTIVE', 'BANNED') default 'ACTIVE'          null,
    created_at  datetime                              default CURRENT_TIMESTAMP not null,
    updated_at  datetime                              default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint email
        unique (email)
);

create table user_agree_terms
(
    id        bigint auto_increment
        primary key,
    user_id   bigint                               not null,
    terms_id  bigint                               not null,
    is_agreed tinyint(1) default 0                 not null,
    agreed_at datetime   default CURRENT_TIMESTAMP not null,
    constraint user_agree_terms_ibfk_1
        foreign key (user_id) references user (id)
            on delete cascade,
    constraint user_agree_terms_ibfk_2
        foreign key (terms_id) references terms (id)
            on delete cascade
);

create index terms_id
    on user_agree_terms (terms_id);

create index user_id
    on user_agree_terms (user_id);

create table user_mission
(
    id           bigint auto_increment
        primary key,
    user_id      bigint                                                     not null,
    mission_id   bigint                                                     not null,
    status       enum ('CHALLENGING', 'COMPLETE') default 'CHALLENGING'     null,
    started_at   datetime                         default CURRENT_TIMESTAMP not null,
    completed_at datetime                                                   null,
    constraint uq_user_mission
        unique (user_id, mission_id),
    constraint user_mission_ibfk_1
        foreign key (user_id) references user (id)
            on delete cascade,
    constraint user_mission_ibfk_2
        foreign key (mission_id) references mission (id)
            on delete cascade
);

create table review
(
    id              bigint auto_increment
        primary key,
    user_id         bigint                             not null,
    store_id        bigint                             not null,
    user_mission_id bigint                             not null,
    body            text                               not null,
    score           float                              not null,
    created_at      datetime default CURRENT_TIMESTAMP not null,
    updated_at      datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint user_mission_id
        unique (user_mission_id),
    constraint review_ibfk_1
        foreign key (user_id) references user (id)
            on delete cascade,
    constraint review_ibfk_2
        foreign key (store_id) references store (id)
            on delete cascade,
    constraint review_ibfk_3
        foreign key (user_mission_id) references user_mission (id)
            on delete cascade
);

create index store_id
    on review (store_id);

create index user_id
    on review (user_id);

create index mission_id
    on user_mission (mission_id);

create definer = root@localhost trigger trg_region_mission_complete
    after update
    on user_mission
    for each row
BEGIN
    DECLARE complete_count INT;

    -- 완료 상태로 변경됐을 때만 실행
    IF NEW.status = 'COMPLETE' AND OLD.status = 'CHALLENGING' THEN

        -- 같은 지역 내 완료된 미션 수 카운트
        SELECT COUNT(*) INTO complete_count
        FROM user_mission um
        JOIN mission m ON um.mission_id = m.id
        JOIN store s ON m.store_id = s.id
        JOIN mission m2 ON m2.id = NEW.mission_id
        JOIN store s2 ON m2.store_id = s2.id
        WHERE um.user_id = NEW.user_id
          AND um.status = 'COMPLETE'
          AND s.region_id = s2.region_id;

        -- 10의 배수일 때마다 1000 포인트 지급
        IF complete_count % 10 = 0 THEN
            UPDATE user
            SET point = point + 1000
            WHERE id = NEW.user_id;
        END IF;

    END IF;
END;

create table user_prefer_category
(
    id               bigint auto_increment
        primary key,
    user_id          bigint not null,
    food_category_id bigint not null,
    constraint user_prefer_category_ibfk_1
        foreign key (user_id) references user (id)
            on delete cascade,
    constraint user_prefer_category_ibfk_2
        foreign key (food_category_id) references food_category (id)
            on delete cascade
);

create index food_category_id
    on user_prefer_category (food_category_id);

create index user_id
    on user_prefer_category (user_id);

