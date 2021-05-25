import { APIGatewayEvent, Context, Callback } from "aws-lambda";

export const handler = async (
  event: APIGatewayEvent,
  context: Context,
  callback: Callback
) => {
  try {
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": true,
      },
      body: "Hello world!"
    }
  } catch (err) {
    callback(err);
  }
};
