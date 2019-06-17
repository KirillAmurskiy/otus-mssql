Use RedStrike;
go

CREATE TYPE EmailType FROM VARCHAR(254);
go

create type PhoneNumberType from varchar(20);
go

create table Worker(
    WorkerId bigint IDENTITY(1,1) primary key,
    FullName nvarchar NOT NULL ,
    EmailAddress EmailType,
    PhoneNumber PhoneNumberType
);
go

create table Employment(
    EmploymentId bigint IDENTITY(1,1) primary key,
    Post nvarchar NOT NULL
);
go

create table Company(
    CompanyId bigint identity(1,1) primary key,
    Name nvarchar not null
);
go

create table Address(
    AddressId bigint identity(1,1) primary key,
    PostCode varchar(20),
    Street nvarchar,
    Building nvarchar,
    Flat nvarchar
);
go

create table Country(
    CountryId bigint identity(1,1) primary key,
    Name varchar
);
go

create table City(
    CityId bigint identity(1,1) primary key,
    Name varchar
);
go

create table CompanyHasAddress(

);
go

create table TradeUnion(
    TradeUnionId bigint identity(1,1) primary key,
    Name nvarchar,
    FoundationDate date
)

