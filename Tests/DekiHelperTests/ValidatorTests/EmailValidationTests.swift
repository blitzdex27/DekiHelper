//
//  EmailValidationTests.swift
//  
//
//  Created by Dexter Ramos on 9/16/23.
//

import XCTest
@testable import DekiHelper

final class EmailValidationTests: XCTestCase {

    let topLevelDomains: [String] = {
        if let domains = try? DekiParser.setupModel([String].self, fileName: "topLevelDomains", type: .yaml, bundle: .init(for: EmailValidationTests.self)) {
            return domains
        } else {
            return []
        }
    }()

    func testEmailSimple() {
        var emails = [
            "user27@example.com",
            "john.doe@example.com",
            "jane_doe@example.com",
            "john.johnny.doe@example.com",
            "user1@example.com",
            "john.doe1@example.com",
            "jane_doe1@example.com",
            "john.johnny.doe1@example.com",
        ]
        
        for email in emails {
            XCTAssertTrue(DekiValidator.validateEmail(email))
        }
    }

    func testEmailWithPlusSign() {
        var emails = [
            "user+support@example.com",
            "jane+123@example.com",
            "info+sales@example.com",
        ]
        
        for email in emails {
            XCTAssertTrue(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

    func testEmailAlphaOnly() {
        var emails = [
            "a@b.cd",
            "a@b.cde",
            "user@example.com",
            "user.reuse@example.com",
            "user.reuse.reduce@example.com",
            "user.reuse.reduce.recycle@example.com",
            "qwertyuiopasdfghjklzxcvbnm@example.com",
            "q.w.e.r.t.y.u.i.o.p.a.s.d.f.g.h.j.k.l.z.x.c.v.b.n.m@example.com",
            "qwertyuiopasdfghjklzxcvbnm.qwertyuiopasdfghjklzxcvbnm.qwertyuiopasdfghjklzxcvbnm@example.com",
        ]
        
        for email in emails {
            XCTAssertTrue(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

    func testEmailAlphaNumericOnly() {
        var emails = [
            "a1@b.cd",
            "a2@b.cde",
            "us3er@example.com",
            "use4r.re5use@example.com",
            "u7ser.reu6se.r8educe@example.com",
            "us9er.re0use.red1uce.rec2ycle@example.com",
            "qwe3rtyuiopasdf4ghjkl5zxc6vbn7m@example.com",
            "q.w.e.r18.t.y.u.i.o.p.a.s.d.f.19g.h.j.k.l.z.20x.c.v.b21.n.m@example.com",
            "qwer22tyuiopa23sdfghjklzxc24vbnm.qw25ertyuiopa26sdfghj27klzxc28vbnm.qwerty29uiopasdfghjklzxcvbnm@example.com",
            "30a@b.cd",
            "a31@b.cde",
            "32user9@example.com",
            "use33r.reuse0@example.com",
            "5user.reuse.reduce@example1.com",
            "7user.reuse.reduce.recycle@example.com",
            "8qwertyuiopasdfghjklzxcvbnm@example.com",
            "9q.w.e.r.t.y.u.i.o.p.a.s.d.f.g.h.j.k.l.z.x.c.v.b.n.m@example.com",
            "0qwertyuiopasdfghjklzxcvbnm.qwertyuiopasdfghjklzxcvbnm.qwertyuiopasdfghjklzxcvbnm@example.com",
        ]
        
        for email in emails {
            XCTAssertTrue(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

    ///  Local part can contain alphabetic, numeric, and these symbols: !#$%&'*+-/=?^_`{|}~ (RFC 2822, section 3.4.1)
    func testEmailWithAllowedSpecialCharacters() {
        var emails = [
            "!u!!s!er!@example.com",
            "#u##s#er#@example.com",
            "&u&&s&er&@example.com",
            "$u$$s$er$@example.com",
            "%u%%s%er%@example.com",
            "'u''s'er'@example.com",
            "*u**s*er*@example.com",
            "+u++s+er+@example.com",
            "-u--s-er-@example.com",
            "/u//s/er/@example.com",
            "=u==s=er=@example.com",
            "?u??s?er?@example.com",
            "^u^^s^er^@example.com",
            "_u__s_er_@example.com",
            "`u``s`er`@example.com",
            "{u{{s{er{@example.com",
            "|u||s|er|@example.com",
            "}u}}s}er}@example.com",
            "~u~~s~er~@example.com",
        ]
        
        for email in emails {
            XCTAssertTrue(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

    /// Local part can be enclosed with quotes
    ///
    /// - no character restriction inside quotes as long as it is not a backslash or quote
    /// - quoted local part can accepts quotes and backslashes as long as they are preceded by backslash
    func testEmailQuoted() {
        /*
         "user"@example.com
         "john doe"@example.com
         "jane_doe"@example.com
         "john\\ \\doe"@example.com
         "john\\ doe\"@example.com
         "john \"johnny\" doe"@example.com
         "john \"johnny doe"@example.com
         */
        var emails = [
            "\"user\"@example.com",
            "\"john doe\"@example.com",
            "jane_doe@example.com",
            "\"john\\ \\doe\"@example.com",
            "\"john\\ doe\"@example.com",
            "\"john \\\"johnny\\\" doe\"@example.com",
            "\"john \\\"johnny doe\"@example.com",
        ]
        
        for email in emails {
            XCTAssertTrue(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

    /// - local part of the email address should be interpreted and treated as case-sensitive by the receiving email server (RFC 5321)
    /// - in practice, most email providers and servers, including Google ignore case sensitivity
    func testEmailCaseInsensitivity() {
        var validEmails = [
            "uSeR@example.com",
            "uSeR.uSEr@example.com",
            "usEr.useR.usEr@example.com",
            "usEr_useR+usEr@example.com",
        ]
        
        for email in validEmails {
            XCTAssertTrue(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

    // MARK: - Email Domain part tests

    func testEmailWithSubDomain() {
        var emails = [
            "info@sub.example.com",
            "sales@sub.sub.example.com",
            "contact@sub2.sub1.example.com",
        ]
        
        for email in emails {
            XCTAssertTrue(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

    func testEmailWithDifferentTopLevelDomains() {
        var emails = [
            "user@example.co.uk",
            "contact@example.org",
            "john.doe@example.net",
            "user@example.com.ph",
        ]
        
        for email in emails {
            XCTAssertTrue(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

    /// Test with valid top level domains listed by IANA (Internet Assigned Numbers Authority)
    ///
    /// Reference: https://data.iana.org/TLD/tlds-alpha-by-domain.txt
    func testEmailWithAllTopLevelDomains() {
        let validEmails = [
            "user@example.com.uk",
            "info@sub.example.com.ph",
            "contact@sub2.sub1.example.com",
            "jane+1etic23@example.com.au",
        ]
        
        for email in validEmails {
            for tld in self.topLevelDomains {
                let modifiedEmail = email.replacingOccurrences(of: ".com", with: ".\(tld)")
                XCTAssertTrue(DekiValidator.validateEmail(modifiedEmail), "Email validation failed for \(email) - \(modifiedEmail)")
            }
        }
    }

    // MARK: - Test invalid emails

    func testInvalidEmails() {
        var invalidEmails = [
            "abc_def.example.com",
            "user@example",
            "user@.com",
            "user@com",
            "user@name@example.com",
            "user@name@example..com",
            "user@example..com",
            "user..us@example.com",
            "user...us@example.com",
            "user..use@example.com",
            "user..user@example.com",
            "user...use@example.com",
            "user.ue..a.se@example.com",
            "user...user@example.com",
            "user@example.",
            "user@com",
            "user@-example.com",
            "user@example.com!",
            "user{at}example.com",
            "user@example_com",
            "user@example.com?",
            "user@example..com",
            "us\"er@example..com",
            "us\\er@example..com",
            "user@examp`le.com",
            "user@exam~le.com",
            "user@exam!le.com",
            "user@exam@le.com",
            "user@exam#le.com",
            "user@exam$le.com",
            "user@exam%le.com",
            "user@exam^le.com",
            "user@exam&le.com",
            "user@exam*le.com",
            "user@exam(le.com",
            "user@exam)le.com",
            "user@exam{le.com",
            "user@exam}le.com",
            "user@exam[le.com",
            "user@exam]le.com",
            "user@exam|le.com",
            "user@exam\\le.com",
            "user@exam/le.com",
            "user@exam:le.com",
            "user@exam;le.com",
            "user@exam\"le.com",
            "user@exam'le.com",
            "user@exam<le.com",
            "user@exam>le.com",
            "user@exam,le.com",
            "user@exam?le.com",
            "user@-examle.com",
            "user@--exam?le.com",
            "user@-exam?le.com",
            "user@.example.com",
            "user@..example.com",
            "\"user@exampple.com",
            "plainaddress", // reference: https://gist.github.com/cjaoude/fd9910626629b53c4d25
            "#@%^%#$@#$@#.com",
            "@example.com",
            "Joe Smith <email@example.com>",
            "email.example.com",
            "email@example@example.com",
            ".email@example.com",
            "email.@example.com",
            "email..email@example.com",
            "email@example.com (Joe Smith)",
            "email@-example.com",
            "email@example..com",
            "Abc..123@example.com",
            "\"(),:;<>[\\]@example.com",
            "just”not”right@example.com",
            #"this\\ is\"really\"not\allowed@example.com"#,
        ]
        
        for email in invalidEmails {
            XCTAssertFalse(DekiValidator.validateEmail(email), "Email validation failed for \(email)")
        }
    }

}

/// References
/// - https://emailregex.com/email-validation-summary/
/// - https://stackoverflow.com/questions/201323/how-can-i-validate-an-email-address-using-a-regular-expression
/// - https://en.wikipedia.org/wiki/Email_address
/// - http://www.iana.org/domains/root/db
/// - https://data.iana.org/TLD/tlds-alpha-by-domain.txt
/// - https://gist.github.com/cjaoude/fd9910626629b53c4d25
