'use strict';

// modules
const puppeteer = require('puppeteer');
const fs = require('fs');
const { error } = require('console');

// online compiler url
const URL = 'https://wchargin.github.io/lc3web/';

// input data and bot settings.
const data = JSON.parse(fs.readFileSync('./data.json', 'utf8'));
const code = (JSON.stringify(fs.readFileSync(data.settings.codePath, 'utf8').toString())).replace(/\\r\\n/g, '\n').replace(/"/g, '');
data.testList = [];
data["tests"].forEach( (path, i) => data.testList[i] = (JSON.stringify(fs.readFileSync(path, 'utf8'))).replace(/"/g,'').split('\\r\\n').filter(s => s.length > 0 ) );

// the excepted output creator function
const outputFunctions = require('./expected-output');
const expectedOutput = outputFunctions[`hw0${data.settings.hwNum}Solution`];


// time formatter function (utility)
const timeFormat = (start, end) => {
    const format = (x) => (Math.abs(x) >= 10) ? ''+Math.abs(Math.round(x)) : '0'+Math.abs(Math.round(x)) ;
    return `${format(end.getHours() - start.getHours())}:${format(end.getMinutes() - start.getMinutes())}:${format(end.getSeconds() - start.getSeconds())}`;
}

// ----------------------------------------------

// bot test runner.
(async () => {
    console.log('\n------------------------------------ \n');

    // open browser and page objects.
    const browser = await puppeteer.launch({
        headless: !data.settings.bot.watch,
        defaultViewport: {
            width: data.settings.bot.setViewportWidth,
            height: data.settings.bot.setViewportHeight
        },
        slowMo: data.settings.bot.slowMo,
        args: [
            '--desktop',
            '--start-maximized'
        ]
    });
    const page = await browser.newPage();
    await page.goto(URL);

    // Load the LC3 program.
    await page.waitForSelector('#mem-raw');
    await page.click('#mem-raw');
    await page.waitForSelector('#raw-input-container .form-control');
    await page.$eval('#raw-input-container .form-control', ( (el, value) => el.value = value ), code);
    await page.evaluate( () => {
        let btn = document.querySelector('#btn-process-raw');
        btn && btn.click();
        btn = document.querySelector('#btn-raw-load');
        btn && btn.click();
    });

    
    // Run the input tests (one by one).
    for ( let i = 0 ; i < data.testList.length ; i++ ) {
        // start program.
        await page.evaluate( () => {
            let btn = document.querySelector('#control-run');
            btn && btn.click();
        });

        // time
        let startTime;
        if ( data.settings.time ) { startTime = new Date() }

        // insert current test input.
        await page.click('#console-contents');
        await page.focus('#console-contents');
        for ( const line of data.testList[i] ) {
            await page.keyboard.type(line);
            await page.keyboard.press('Enter');
            await page.evaluate( async () => {
                function sleep (time) { return new Promise ( (resolve) => setTimeout(resolve, time) );}
                const inputBuffer = document.querySelector('#buffered-char-count');
                while ( inputBuffer.innerText != "0" ) { await sleep(15) }
            });
        }
        // wait for current program run to finish (end of output).
        await page.evaluate( async () => {
            function sleep (time) { return new Promise ( (resolve) => setTimeout(resolve, time) );}
            const inputBuffer = document.querySelector('#buffered-char-count');
            const console = document.querySelector('#console-contents');
            while ( inputBuffer.innerText != "0" ) { await sleep(15) }
            while ( !console.innerText.split('\n').splice(-1)[0].includes('----- Halting the processor -----') ) { await sleep(10) }
        });


        // create the correct output.
        const correctOutput = expectedOutput(data.testList[i]);
        if ( data.expectedOutput ) { await fs.writeFileSync(data.settings.outputPath + `/expectedOutput${i+1}.txt`, correctOutput) }
        // get the test run output.
        let output = await page.$eval('#console-contents', e => e.textContent );
        output = output.split('\n').filter( e => !e.includes('Halting the processor') && e != '' ).join('\n');
        await fs.writeFileSync(data.settings.outputPath + `/output${i+1}.txt`, output);
        // take the test run screenshot.
        if ( data.settings.screenshot ) { await page.screenshot({path: data.settings.outputPath + `/output${i+1}.png`}) }


        // return the simulator PC to 'x3000' (for the next run).
        const jumpto = await page.$('#mem-jumpto');
        await jumpto.click({ clickCount: 3 });
        await page.type('#mem-jumpto', 'x3000');
        await page.keyboard.press('Enter');
        await page.evaluate( async () => {
            const movePC = document.querySelector('#memory-table tbody .memory-cell:first-child td:first-child div.dropdown');
            await movePC.querySelector('button.memory-dropdown').click();
            await movePC.querySelector('.dropdown-menu li:first-child a').click();
        });
        // clearing the console.
        await page.waitForSelector('#control-unhalt');
        await page.click('#control-unhalt');
        await page.click('#btn-clear-out');
        // reset registers.
        if ( data.settings.resetRegisters ) {
            await page.click('#reset-registers');
        }
        // reload program.
        if ( data.settings.reloadMachine ) {
            await page.waitForSelector('#mem-raw');
            await page.click('#mem-raw');
            await page.waitForSelector('#raw-input-container .form-control');
            await page.$eval('#raw-input-container .form-control', (el, value) => el.value = value, code);
            await page.evaluate( () => {
                let btn = document.querySelector('#btn-process-raw');
                btn && btn.click();
                btn = document.querySelector('#btn-raw-load');
                btn && btn.click();
            });
        }
        
        // test message.
        console.log(`Test #${i+1} - ${( output.replace(/ /g, '') == correctOutput.replace(/ /g, '') ? 'Passed' : 'Failed' )}${data.settings.time ? ` - Run Time  ` + timeFormat(startTime, new Date()) : `.` }`);
    }
    
    // close browser and page objects (end bot run).
    await browser.close();
    console.log('\nTest Runner Finish. \n');
})();
