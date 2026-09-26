import { remote } from 'webdriverio';

const options = {
    hostname: '127.0.0.1',
    port: 4723,
    path: '/',

    capabilities: {
        platformName: 'Android',
        'appium:automationName': 'UiAutomator2',
        'appium:deviceName': 'emulator-5554',
        'appium:appPackage': 'com.example.student_task_planner',
        'appium:appActivity': '.MainActivity',
        'appium:noReset': true,
    },
};

const driver = await remote(options);

/**
 * Tim nut LOGIN.
 * Neu chua thay, co the ban phim dang che hoac hierarchy chua cap nhat.
 * Thu dong ban phim bang Back roi tim lai.
 */
async function findLoginButton() {

    // Cach 1: accessibility id
    let loginButton = await driver.$('~LOGIN');

    if (await loginButton.isExisting()) {
        return loginButton;
    }

    console.log('Chua thay LOGIN -> thu dong ban phim');

    try {
        await driver.back();
        await driver.pause(1200);
    } catch (error) {
        console.log('Khong can dong ban phim hoac Back khong thuc hien duoc');
    }

    // Thu lai accessibility id
    loginButton = await driver.$('~LOGIN');

    if (await loginButton.isExisting()) {
        return loginButton;
    }

    // Cach 2: Android UiAutomator
    loginButton = await driver.$(
        'android=new UiSelector().description("LOGIN")'
    );

    if (await loginButton.isExisting()) {
        return loginButton;
    }

    // Cach 3: XPath du phong
    loginButton = await driver.$(
        '//android.widget.Button[@content-desc="LOGIN"]'
    );

    if (await loginButton.isExisting()) {
        return loginButton;
    }

    throw new Error('Khong tim thay nut LOGIN');
}


try {

    console.log('');
    console.log('============================');
    console.log('START LOGIN TEST');
    console.log('============================');


    /*
     * STEP 1
     * Neu app hien dang o Home,
     * Logout de dua app ve trang thai Login ban dau.
     */
    console.log('STEP 1: Kiem tra trang thai app');

    const logoutButton = await driver.$('~LOGOUT');

    if (await logoutButton.isExisting()) {

        console.log('App dang o Home -> Logout');

        await logoutButton.click();
        await driver.pause(1200);

    } else {

        console.log('App dang o man Login');

    }


    /*
     * STEP 2
     * Tim Username va Password.
     */
    console.log('STEP 2: Tim Username va Password');

    const usernameField = await driver.$(
        'android=new UiSelector()' +
        '.className("android.widget.EditText")' +
        '.instance(0)'
    );

    const passwordField = await driver.$(
        'android=new UiSelector()' +
        '.className("android.widget.EditText")' +
        '.instance(1)'
    );


    await usernameField.waitForDisplayed({
        timeout: 10000
    });

    await passwordField.waitForDisplayed({
        timeout: 10000
    });

    console.log('Da tim thay 2 o input');


    /*
     * STEP 3
     * Xoa du lieu cu roi nhap Username.
     */
    console.log('STEP 3: Nhap Username');

    await usernameField.click();

    await usernameField.clearValue();

    await driver.pause(300);

    await driver.keys('student');

    await driver.pause(500);

    console.log('Username = student');


    /*
     * STEP 4
     * Xoa du lieu cu roi nhap Password.
     */
    console.log('STEP 4: Nhap Password');

    await passwordField.click();

    await passwordField.clearValue();

    await driver.pause(300);

    await driver.keys('123456');

    await driver.pause(700);

    console.log('Password da nhap');


    /*
     * STEP 5
     * Tim nut LOGIN.
     */
    console.log('STEP 5: Tim nut LOGIN');

    const loginButton = await findLoginButton();

    await loginButton.waitForDisplayed({
        timeout: 10000
    });

    console.log('Da tim thay nut LOGIN');


    /*
     * STEP 6
     * Click LOGIN.
     */
    console.log('STEP 6: Bam LOGIN');

    await loginButton.click();

    console.log('Da bam LOGIN');

    await driver.pause(1500);


    /*
     * STEP 7
     * Kiem tra Home Dashboard.
     * Neu LOGOUT xuat hien tuc la Login thanh cong.
     */
    console.log('STEP 7: Kiem tra Home Dashboard');

    const logoutAfterLogin = await driver.$('~LOGOUT');

    await logoutAfterLogin.waitForDisplayed({
        timeout: 10000
    });

    console.log('');
    console.log('PASS: LOGIN THANH CONG');
    console.log('PASS: DA VAO HOME DASHBOARD');


    /*
     * STEP 8
     * Logout de dua app ve trang thai ban dau.
     */
    console.log('STEP 8: Logout');

    await logoutAfterLogin.click();

    await driver.pause(1000);


    /*
     * Kiem tra da quay lai Login.
     */
    const loginAfterLogout = await driver.$('~LOGIN');

    await loginAfterLogout.waitForDisplayed({
        timeout: 10000
    });

    console.log('PASS: LOGOUT THANH CONG');

    console.log('');
    console.log('============================');
    console.log('TEST COMPLETED SUCCESSFULLY');
    console.log('============================');


} catch (error) {

    console.log('');
    console.log('============================');
    console.log('FAIL: TEST BI LOI');
    console.log('============================');

    console.error(error.message);

} finally {

    try {
        await driver.deleteSession();
    } catch (error) {
        console.log('Session da ket thuc');
    }

}