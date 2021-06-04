// 
// 

// return hw03 correct output.
function hw03Solution (input) {
    let tmp;
    const numOfStudents = input.shift();
    tmp = numOfStudents.split(' ').filter( str => str.length != 0 );
    let course1 = +tmp[0];
    let course2 = +tmp[1];
    let course3 = +tmp[2];

    tmp = '';
    for ( let i = 0 ; i < course1 ; i++ ) {
        tmp += input.shift();
        (i + 1 < course1) && (tmp += '\n');
    }
    course1 = tmp;

    tmp = '';
    for ( let i = 0 ; i < course2 ; i++ ) {
        tmp += input.shift();
        (i + 1 < course2) && (tmp += '\n');
    }
    course2 = tmp;
    
    tmp = '';
    for ( let i = 0 ; i < course3 ; i++ ) {
        tmp += input.shift();
        (i + 1 < course3) && (tmp += '\n');
    }
    course3 = tmp;

    let bestGrades = ((course1.split('\n')).concat( course2.split('\n') , course3.split('\n') ))
                    .map( grades => parseInt(( grades.split(' ').reduce( (a, b) => (+a) + (+b), 0) ) / 4) )
                    .sort( (a, b) => b - a )
                    .filter( (item, pos, self) => self.indexOf(item) == pos );

    for ( let i = 0 ; i < 6 ; i++ ) !bestGrades[i] && (bestGrades[i] = 0);
    while ( bestGrades.length != 6 ) bestGrades.pop();

    return `Enter the number of students in each course: ${numOfStudents}\n` +
    `Enter the student grades in course 1: \n` +
    `${course1}\n` +
    `Enter the student grades in course 2: \n` +
    `${course2}\n` +
    `Enter the student grades in course 3: \n` +
    `${course3}\n` +
    `The six highest scores are: ${bestGrades.join(' ')}`;
}

// return hw04 correct output.
function hw04Solution (input) {
    let str = `Enter N, i.e., number between 1 to 30: ${input}\n`;
    const NQueenSolver = (queen_number, positions, solutions, N) => {
        if ( queen_number === N ) {
            str += `Solution: ${positions.join(' ')} \n`;
            return solutions + 1;
        }
        for ( let i = 0 ; i < N ; i++ ) {
            if ( positions.slice(0,queen_number).every( (e, j) => (e != i) && (e != i-queen_number+j) && (e != i+queen_number-j) ) ) {
                positions[queen_number] = i;
                solutions = NQueenSolver(queen_number + 1, positions, solutions, N);
            }
        }
        return solutions;
    }
    const solutions = NQueenSolver(0, Array(+input).fill(0), 0, +input);
    return str + `Number of possible solutions: ${solutions}`;
}


// 
module.exports.hw03 = hw03Solution;
module.exports.hw04 = hw04Solution;