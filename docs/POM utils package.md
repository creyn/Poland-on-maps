The "Poland on maps" helper utils package to help setup scripts.

Multiple scripts uses the same setup and common functions like fetching the datasets from the internet. I've put them into the custom package.

The code is here: [POM Utils package](../src/packages/POMUtils/)
The final package in the `tar.gz` format is here: [POMUtils_1.0.tar](../src/packages/POMUtils_1.0.tar.gz)

To build new package:
```bash
cd src/packages/
R CMD build POMUtils
```

It will create the [POMUtils_1.1.tar](../src/packages/POMUtils_1.1.tar.gz) package.

