# react-native-qr-local-image-scan

It is used to scan qr codes from local image file.

## Installation

```sh
npm install react-native-qr-local-image-scan
```

## Usage


```js
import { scanCodes } from 'react-native-qr-local-image-scan';

// ...
const scanQrFromLocalImage = async () => {
  const result = await scanCodes('file://path-to-your-file.jpg');
  if (result) {
    // code here
    console.log('codes extracted', result);
  }
}
```


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
