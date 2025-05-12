USE master;
GO

IF EXISTS (SELECT 1 FROM sys.sysdatabases WHERE [name] = 'LinuxPackages')
BEGIN 
   ALTER DATABASE [LinuxPackages] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE [LinuxPackages];
END;
GO

CREATE DATABASE LinuxPackages;
GO

USE LinuxPackages;
GO

-- Create tables
CREATE TABLE [Maintainer] (
 [MaintainerID] Int NOT NULL,
 [Name] Nvarchar(255) NOT NULL,
 [Email] Nvarchar(255) NOT NULL,
 [Team] Nvarchar(100) NULL
) AS NODE;
GO

CREATE TABLE [Repository] (
 [RepositoryID] Int NOT NULL,
 [Name] Nvarchar(255) NOT NULL,
 [Url] Nvarchar(255) NOT NULL,
 [Distro] Nvarchar(100) NOT NULL,
 [Branch] Nvarchar(20) NOT NULL
) AS NODE;
GO

CREATE TABLE [Package] (
 [PackageID] Int NOT NULL,
 [Name] Nvarchar(255) NOT NULL,
 [Version] Nvarchar(30) NOT NULL,
 [Architecture] Nvarchar(20) NOT NULL,
 [Description] Nvarchar(255) NULL
) AS NODE;
GO

CREATE TABLE [DependsOn] AS EDGE;
GO

CREATE TABLE [Maintains] (
 [isPrimaryMaintainer] Bit DEFAULT 1 NOT NULL
) AS EDGE;
GO

CREATE TABLE [InRepository] (
 [Added] Date NOT NULL,
 [Deleted] Date NULL
) AS EDGE;
GO

ALTER TABLE [Maintainer] ADD CONSTRAINT [PK_Maintainer] PRIMARY KEY ([MaintainerID]);
ALTER TABLE [Repository] ADD CONSTRAINT [PK_Repository] PRIMARY KEY ([RepositoryID]);
ALTER TABLE [Package] ADD CONSTRAINT [PK_Package] PRIMARY KEY ([PackageID]);
GO

INSERT INTO [Maintainer] ([MaintainerID], [Name], [Email], [Team]) VALUES 
(1, 'John Smith', 'john.smith@linux.org', 'Web Stack'),
(2, 'Maria Garcia', 'maria.garcia@linux.org', 'Security'),
(3, 'David Johnson', 'david.johnson@linux.org', 'Language Runtimes'),
(4, 'Sarah Williams', 'sarah.williams@linux.org', 'Database'),
(5, 'Michael Brown', 'michael.brown@linux.org', 'Kernel'),
(6, 'Emily Davis', 'emily.davis@linux.org', 'Desktop'),
(7, 'Robert Wilson', 'robert.wilson@linux.org', 'Containers'),
(8, 'Jennifer Miller', 'jennifer.miller@linux.org', 'JavaScript'),
(9, 'William Taylor', 'william.taylor@linux.org', 'Editors'),
(10, 'Jessica Anderson', 'jessica.anderson@linux.org', 'Shell'),
(11, 'Christopher Martinez', 'christopher.martinez@linux.org', 'Networking');
GO

INSERT INTO [Repository] ([RepositoryID], [Name], [Url], [Distro], [Branch]) VALUES 
(1, 'Ubuntu Main', 'http://archive.ubuntu.com/ubuntu', 'Ubuntu', '22.04 LTS'),
(2, 'Debian Stable', 'http://deb.debian.org/debian', 'Debian', '11 (Bullseye)'),
(3, 'Fedora Updates', 'http://download.fedoraproject.org/pub/fedora/linux/updates', 'Fedora', '36'),
(4, 'CentOS Base', 'http://mirror.centos.org/centos', 'CentOS', '8'),
(5, 'Arch Linux Core', 'http://mirrors.kernel.org/archlinux/core/os/x86_64', 'Arch', 'Core'),
(6, 'OpenSUSE Leap', 'http://download.opensuse.org/distribution/leap', 'OpenSUSE', '15.4'),
(7, 'Ubuntu Universe', 'http://archive.ubuntu.com/ubuntu', 'Ubuntu', '22.04 LTS'),
(8, 'Debian Testing', 'http://deb.debian.org/debian', 'Debian', 'Bookworm'),
(9, 'Fedora Rawhide', 'http://download.fedoraproject.org/pub/fedora/linux/development', 'Fedora', 'Rawhide'),
(10, 'CentOS Stream', 'http://mirror.stream.centos.org', 'CentOS', '9'),
(11, 'Arch Linux Extra', 'http://mirrors.kernel.org/archlinux/extra/os/x86_64', 'Arch', 'Extra');
GO

INSERT INTO [Package] ([PackageID], [Name], [Version], [Architecture], [Description]) VALUES 
(1, 'nginx', '1.18.0-6ubuntu1', 'amd64', 'High performance web server'),
(2, 'openssl', '3.0.2-0ubuntu1', 'amd64', 'Cryptography and SSL/TLS toolkit'),
(3, 'python3', '3.9.2-1', 'amd64', 'Python programming language'),
(4, 'postgresql', '13.4-1', 'amd64', 'PostgreSQL database'),
(5, 'linux-kernel', '5.15.0-25-generic', 'amd64', 'Linux kernel'),
(6, 'firefox', '102.0-1', 'amd64', 'Mozilla Firefox web browser'),
(7, 'docker-ce', '20.10.12-1', 'amd64', 'Containerization platform'),
(8, 'nodejs', '16.13.1-1', 'amd64', 'JavaScript runtime'),
(9, 'vim', '8.2.3995-1', 'amd64', 'Vi IMproved text editor'),
(10, 'bash', '5.1.8-1', 'amd64', 'GNU Bourne Again SHell'),
(11, 'openssh-server', '8.9p1-1', 'amd64', 'Secure shell server'),
(12, 'libssl-dev', '3.0.2-0ubuntu2', 'amd64', 'SSL development libraries'),
(13, 'libpython3.9', '3.9.2-1', 'amd64', 'Python shared libraries'),
(14, 'libpq5', '13.4-1', 'amd64', 'PostgreSQL client library'),
(15, 'libedit2', '3.1-20210910', 'amd64', 'Command line editor library'),
(16, 'ca-certificates', '20211016', 'amd64', 'Common CA certificates');
GO

INSERT INTO [InRepository] ($from_id, $to_id, [Added], [Deleted]) VALUES
((SELECT $node_id FROM [Package] WHERE [PackageID] = 1), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 1), '2022-01-15', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 2), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 1), '2022-03-10', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 10), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 1), '2022-04-15', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 12), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 1), '2022-01-20', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 16), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 1), '2022-01-01', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 3), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 2), '2022-02-20', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 4), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 2), '2022-01-05', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 11), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 2), '2022-05-01', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 13), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 2), '2022-02-25', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 14), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 2), '2022-01-10', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 15), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 2), '2022-03-15', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 16), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 2), '2022-01-01', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 5), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 3), '2022-04-01', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 6), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 3), '2022-05-15', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 7), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 3), '2022-03-25', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 16), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 4), '2022-01-01', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 8), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 5), '2022-02-10', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 9), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 5), '2022-01-20', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 6), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 7), '2022-06-01', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 8), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 8), '2022-06-15', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 9), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 9), '2022-06-15', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 10), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 10), '2022-06-15', NULL),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 11), (SELECT $node_id FROM [Repository] WHERE [RepositoryID] = 11), '2022-06-15', NULL);
GO

INSERT INTO [Maintains] ($from_id, $to_id, [isPrimaryMaintainer]) VALUES
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 1), (SELECT $node_id FROM [Package] WHERE [PackageID] = 1), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 1), (SELECT $node_id FROM [Package] WHERE [PackageID] = 2), 0),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 2), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 11), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 3), (SELECT $node_id FROM [Package] WHERE [PackageID] = 3), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 3), (SELECT $node_id FROM [Package] WHERE [PackageID] = 8), 0),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 4), (SELECT $node_id FROM [Package] WHERE [PackageID] = 4), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 5), (SELECT $node_id FROM [Package] WHERE [PackageID] = 5), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 6), (SELECT $node_id FROM [Package] WHERE [PackageID] = 6), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 7), (SELECT $node_id FROM [Package] WHERE [PackageID] = 7), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 8), (SELECT $node_id FROM [Package] WHERE [PackageID] = 8), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 9), (SELECT $node_id FROM [Package] WHERE [PackageID] = 9), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 10), (SELECT $node_id FROM [Package] WHERE [PackageID] = 10), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 11), (SELECT $node_id FROM [Package] WHERE [PackageID] = 11), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 12), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 16), 1),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 3), (SELECT $node_id FROM [Package] WHERE [PackageID] = 13), 0),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 4), (SELECT $node_id FROM [Package] WHERE [PackageID] = 14), 0),
((SELECT $node_id FROM [Maintainer] WHERE [MaintainerID] = 9), (SELECT $node_id FROM [Package] WHERE [PackageID] = 15), 0);
GO

INSERT INTO [DependsOn] ($from_id, $to_id) VALUES
((SELECT $node_id FROM [Package] WHERE [PackageID] = 1), (SELECT $node_id FROM [Package] WHERE [PackageID] = 12)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 12), (SELECT $node_id FROM [Package] WHERE [PackageID] = 2)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 16)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 8), (SELECT $node_id FROM [Package] WHERE [PackageID] = 3)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 3), (SELECT $node_id FROM [Package] WHERE [PackageID] = 13)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 13), (SELECT $node_id FROM [Package] WHERE [PackageID] = 15)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 4), (SELECT $node_id FROM [Package] WHERE [PackageID] = 14)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 14), (SELECT $node_id FROM [Package] WHERE [PackageID] = 2)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 16)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 7), (SELECT $node_id FROM [Package] WHERE [PackageID] = 12)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 16)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 11), (SELECT $node_id FROM [Package] WHERE [PackageID] = 12)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 16)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 10), (SELECT $node_id FROM [Package] WHERE [PackageID] = 15)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 6), (SELECT $node_id FROM [Package] WHERE [PackageID] = 2)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 16)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 5), (SELECT $node_id FROM [Package] WHERE [PackageID] = 2)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 2), (SELECT $node_id FROM [Package] WHERE [PackageID] = 16)),
((SELECT $node_id FROM [Package] WHERE [PackageID] = 9), (SELECT $node_id FROM [Package] WHERE [PackageID] = 15));
GO

-- find packages maintained by (John Smith)
SELECT p.Name AS PackageName, p.Version
FROM Maintainer m, Maintains MN, Package p
WHERE MATCH(p<-(MN)-m)
AND m.Name = 'John Smith';

--find dependencies for nginx (depth 2)
SELECT dep.Name AS DependencyName, dep.Version
FROM Package p, DependsOn d1, Package dep
WHERE MATCH(p-(d1)->dep)
AND p.Name = 'nginx'
    UNION
SELECT dep2.Name AS DependencyName, dep2.Version
FROM Package p, DependsOn d1, Package dep1, DependsOn d2, Package dep2
WHERE MATCH(p-(d1)->dep1-(d2)->dep2)
AND p.Name = 'nginx';

--find packages in Ubuntu Main with their maintainers
SELECT p.Name AS Package, m.Name AS Maintainer, m.Team
FROM Repository r, InRepository ir, Package p, Maintains MN, Maintainer m
WHERE MATCH(p-(ir)->r AND p<-(MN)-m)
AND r.Name = 'Ubuntu Main';


--find packages, that depend on openssl 
SELECT p.Name AS DependentPackage, p.Version
FROM Package p, DependsOn d, Package dep
WHERE MATCH(p-(d)->dep)
AND dep.Name = 'openssl';

--find packages in Debian Stable, that depend on libssl-dev
SELECT p1.Name AS PackageName, p1.Version
FROM Repository r, InRepository ir, Package p1, DependsOn d, Package p2
WHERE MATCH(p2<-(d)-p1-(ir)->r)
AND r.Name = 'Debian Stable'
AND p2.Name = 'libssl-dev';


--find package query that nginx depends on
SELECT p1.Name AS StartPackage,
    STRING_AGG(dep.Name, '->') WITHIN GROUP (GRAPH PATH) AS DependencyPath
FROM 
    Package p1,
    Package FOR PATH AS dep,
    DependsOn FOR PATH AS d
WHERE MATCH(SHORTEST_PATH(p1(-(d)->dep)+)) AND
    p1.Name = 'nginx'

--find dependency query where tha last package is maintained by William Taylor
SELECT p1.Name AS StartPackage,
    STRING_AGG(dep.Name, '->') WITHIN GROUP (GRAPH PATH) AS DependencyPath
FROM 
    Package p1,
    Package FOR PATH AS dep,
    DependsOn FOR PATH AS d,
    Maintains M,
    Maintainer m1
WHERE MATCH(SHORTEST_PATH(p1(-(d)->dep){1, 4}) AND LAST_NODE(dep)<-(M)-m1) AND
    m1.Name = 'William Taylor'