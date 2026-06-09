import { uniqueName } from '../unique.js';

export function newDataSetPayload() {
  return {
    dataSetType: 'normal',
    deviceId: uniqueName('TestDevice'),
    deviceManufacturers: ['Test Manufacturer'],
    deviceModel: 'Test Model',
    deviceSerialNumber: uniqueName('SN'),
    deviceTags: ['cgm'],
    time: new Date().toISOString(),
    timeProcessing: 'none',
    timezone: 'US/Pacific',
    timezoneOffset: -480,
    client: {
      name: 'integration-tests',
      version: '1.0.0',
    },
  };
}

export function newContinuousDataSetPayload() {
  return {
    ...newDataSetPayload(),
    dataSetType: 'continuous',
  };
}

export function sampleCbgDatum() {
  return {
    type: 'cbg',
    units: 'mg/dL',
    value: 120,
    time: new Date().toISOString(),
    deviceId: 'test-device',
    uploadId: '',  // to be filled by caller
  };
}
