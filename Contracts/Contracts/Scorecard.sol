//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

contract Scorecard {
    address public teacher;
    uint256 studentCount = 0;

    constructor() {
        teacher = msg.sender;
    }

    event studentAdded(string memory StudentFirstName, string memory StudentLastName, uint256 StudentId);

    event studentScoreAdded(uint256 _studentId,
        uint256 _englishScore,
        uint256 _mathScore,
        uint256 _scienceScore);

    struct StudentDetails {
        string studentFirstName;
        string StudentLastName;
        uint256 Id;
    }

    struct Score {
        uint256 studentId;
        uint256 englishScore;
        uint256 mathScore;
        uint256 scienceScore;
    }

    modifier onlyClassTeacher(address _teacher) {
        require(teacher == _teacher, "Not_teacher");
        _;
    }

    mapping(uint256 => StudentDetails) Student;

    mapping(uint256 => Score) scoreDetails;

    function addStudentDetails(
        string memory _studentFirstName,
        string memory _StudentLastName
    ) public onlyClassTeacher(msg.sender) {
        StudentDetails storage studentObj = Student[studentCount];
        studentObj.studentFirstName = _studentFirstName;
        studentObj.StudentLastName = _StudentLastName;
        studentObj.Id = studentCount;
        studentCount++;

        emit studentAdded(_studentFirstName, _StudentLastName, studentCount);
    }

    function addScore(
        uint256 _studentId,
        uint256 _englishScore,
        uint256 _mathScore,
        uint256 _scienceScore
    ) public onlyClassTeacher(msg.sender) {
        Score storage studentScore = scoreDetails[_studentId];

        studentScore.englishScore = _englishScore;
        studentScore.mathScore = _mathScore;
        studentScore.scienceScore = _scienceScore;
        studentScore.studentId = _studentId;

        emit studentScoreAdded(_studentId, _englishScore, _mathScore,_scienceScore);
    }
}
