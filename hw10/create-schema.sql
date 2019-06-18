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

create table Company(
    CompanyId bigint identity(1,1) primary key,
    Name nvarchar not null
);
go

create table Employment(
    EmploymentId bigint IDENTITY(1,1) primary key,
    WorkerId bigint
		constraint FK_Employment_Worker_WorkerId
			references Worker,
	CompanyId bigint
		constraint FK_Employment_Company_CompanyId
			references Company,
    Post nvarchar NOT NULL
);
go

create index IX_Employment_WorkerId
	on Employment (WorkerId)
go

create index IX_Employment_CompanyId
	on Employment (CompanyId)
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

create table Address(
    AddressId bigint identity(1,1) primary key,
    PostCode varchar(20),
    Street nvarchar,
    Building nvarchar,
    Flat nvarchar,
    CityId bigint
        constraint FK_Address_City_CityId
            references City,
    CountryId bigint
        constraint FK_Address_Country_CountryId
            references Country
);
go

create index IX_Address_CityId
    on Address(CityId)
go

create index IX_Address_CountryId
    on Address(CountryId)
go

create table CompanyHasAddress(
    CompanyHasAddressId bigint identity(1,1) primary key,
    CompanyAddressType varchar(20) not null check (CompanyAddressType in ('LegalAddress', 'PhysicalAddress')),
    CompanyId bigint
        constraint FK_CompanyHasAddress_Company_CompanyId
            references Company,
    AddressId bigint
        constraint FK_CompanyHasAddress_Address_AddressId
            references Address
);
go

create index IX_CompanyHasAddress_CompanyId
    on CompanyHasAddress(CompanyId)
go

create index IX_CompanyHasAddress_AddressId
    on CompanyHasAddress(AddressId)
go


create table TradeUnion(
    TradeUnionId bigint identity(1,1) primary key,
    Name nvarchar,
    FoundationDate date,
    ReadinessToStrike VARCHAR(15) NOT NULL CHECK (ReadinessToStrike IN('Ready', 'Registration', 'Unknown', 'NotReady'))
);
go

create table WorkerInTradeUnion(
    WorkerInTradeUnionId bigint identity(1,1) primary key,
    Role varchar(20) not null check (Role in ('President', 'MemberOfCouncil', 'Unknown')),
    WorkerId bigint
        constraint FK_WorkerInTradeUnion_Worker_WorkerId
            references Worker,
    TradeUnionId bigint constraint FK_WorkerInTradeUnion_TradeUnion_TradeUnionId
        references TradeUnion
)

create index IX_WorkerInTradeUnion_WorkerId
    on WorkerInTradeUnion(WorkerId)
go

create index IX_WorkerInTradeUnion_TradeUnionId
    on WorkerInTradeUnion(TradeUnionId)
go

create table Strike(
    StrikeId bigint identity(1,1) primary key,
    Theme nvarchar,
    DataFrom datetime,
    DateTo datetime
);
go

create table TradeUnionOnStrike(
    TradeUnionOnStrikeId bigint identity(1,1) primary key,
    DateFrom datetime,
    DateTo datetime,
    TradeUnionId bigint constraint FK_TradeUnionOnStrike_TradeUnion_TradeUnionId references TradeUnion,
    StrikeId bigint constraint FK_TradeUnionOnStrike_Strike_StrikeId references Strike,
    AddressId bigint constraint FK_TradeUnionOnStrike_Address_AddressId references Address
);

create index IX_TradeUnionOnStrike_TradeUnionId
    on TradeUnionOnStrike(TradeUnionId)
go

create index IX_TradeUnionONStrike_StrikeId
    on TradeUnionOnStrike(StrikeId)
go

create index IX_TradeUnionOnStrike_AddressId
    on TradeUnionOnStrike(AddressId)
go

