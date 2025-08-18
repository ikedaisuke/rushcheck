# ⚠️ Archived and Deprecated: Do Not Use

This `rushcheck` gem repository is no longer actively maintained. Due to several critical issues, we **strongly advise against using it in any project**.

Key Issues:

1. **End of Life:** This project has been archived and will not receive any further updates, bug fixes, or security patches.
2. **Incompatibility:** The gem is not compatible with modern versions of Ruby and will likely fail to run.
3. **CRITICAL SECURITY VULNERABILITIES:** This gem depends on outdated libraries with **critical security vulnerabilities.** Running this gem poses a significant and immediate security risk to your system. Please note that the developers of these libraries have since resolved these issues in their newer versions. The following dependencies, as used in this gem, have known CVEs, some of which are **CRITICAL:**
   - `rdoc` < 3.12.1 : **CVE-2013-0256 Moderate severity**
   - `rake` <= 12.3.2 : **CVE-2020-8130 Moderate severity**
   - `bundler` < 2.2.33 :
     - **CVE-2016-7954 Critical severity**
     - **CVE-2016-7954 Critical severity**
     - **CVE-2021-43809 Moderate severity**
     - **CVE-2013-0334 Moderate severity**
   - `git` < 1.11.0
     - **CVE-2022-25648 Critical severity**
     - **CVE-2022-46648 High severity**
     - **CVE-2022-47318 High severity**

# Alternatives

## Ruby

We highly recommend finding an alternative gem for your needs. Here are a few projects with similar functionality that you might consider. Please note that not all of these are actively maintained, so check their status before using them.

- [ruby-prop_check](https://github.com/Qqwy/ruby-prop_check)
- [rantly](https://github.com/rantly-rb/rantly)
- [pbt](https://github.com/ohbarye/pbt)
- [Propr](https://github.com/kputnam/propr)

## Other Languages

For similar projects in other programming languages, you can explore them on GitHub's topics page:
- [quickcheck](https://github.com/topics/quickcheck)